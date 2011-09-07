//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWSpec.h"
#import <objc/runtime.h>
#import "KWAfterAllNode.h"
#import "KWAfterEachNode.h"
#import "KWBeforeAllNode.h"
#import "KWBeforeEachNode.h"
#import "KWContextNode.h"
#import "KWExampleGroup.h"
#import "KWExampleGroupBuilder.h"
#import "KWExampleNode.h"
#import "KWExistVerifier.h"
#import "KWFailure.h"
#import "KWIntercept.h"
#import "KWItNode.h"
#import "KWMatchVerifier.h"
#import "KWAsyncVerifier.h"
#import "KWMatcherFactory.h"
#import "KWObjCUtilities.h"
#import "KWRegisterMatchersNode.h"
#import "KWStringUtilities.h"
#import "KWVerifying.h"
#import "KWWorkarounds.h"
#import "NSMethodSignature+KiwiAdditions.h"

@interface KWSpec()

#pragma mark -
#pragma mark Properties

@property (nonatomic, retain) KWExampleGroup *exampleGroup;
@property (nonatomic, readonly) NSMutableArray *exampleNodeStack;

@end

@implementation KWSpec

@synthesize exampleGroup;
@synthesize exampleNodeStack;

- (id)initWithInvocation:(NSInvocation *)anInvocation
{
    if ((self = [super initWithInvocation:anInvocation])) {
        exampleNodeStack = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark -
#pragma mark Initializing

- (void)dealloc 
{
    [exampleNodeStack release];
    [exampleGroup release];
    [super dealloc];
}

+ (void)buildExampleGroups {
}

#pragma mark -
#pragma mark Reporting Failures

- (NSString *)descriptionForExampleContext {
    NSMutableString *description = [NSMutableString string];

    for (id<KWExampleNode> node in self.exampleNodeStack) {
        NSString *nodeDescription = [node description];

        if (nodeDescription != nil)
            [description appendFormat:@"%@ ", nodeDescription];
    }

    // Remove trailing space
    if ([description length] > 0)
        [description deleteCharactersInRange:NSMakeRange([description length] - 1, 1)];

    return description;
}

- (KWFailure *)outputReadyFailureWithFailure:(KWFailure *)aFailure {
    NSString *annotatedFailureMessage = [NSString stringWithFormat:@"\"%@\" FAILED, %@",
                                                                   [self descriptionForExampleContext],
                                                                    aFailure.message];

#if TARGET_IPHONE_SIMULATOR
    // \uff1a is the unicode for a fill width colon, as opposed to a regular
    // colon character (':'). This escape is performed so that Xcode doesn't
    // truncate the error output in the build results window, which is running
    // build time specs.
    annotatedFailureMessage = [annotatedFailureMessage stringByReplacingOccurrencesOfString:@":" withString:@"\uff1a"];
#endif // #if TARGET_IPHONE_SIMULATOR

    return [KWFailure failureWithCallSite:aFailure.callSite message:annotatedFailureMessage];
}

- (void)reportFailure:(KWFailure *)aFailure; {
    KWFailure *outputReadyFailure = [self outputReadyFailureWithFailure:aFailure];
    [self failWithException:[outputReadyFailure exceptionValue]];
}

#pragma mark -
#pragma mark Getting Invocations

// Called by the SenTestingKit test suite to get an array of invocations that
// should be run on instances of test cases.
+ (NSArray *)testInvocations {
    SEL selector = @selector(buildExampleGroups);

    // Only return invocation if the receiver is a concrete spec that has
    // overridden -buildExampleGroups.
    if ([self methodForSelector:selector] == [KWSpec methodForSelector:selector])
        return nil;

    // Add a single invocation for -runSpec.
    NSString *encoding = KWEncodingForVoidMethod();
    NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:[encoding UTF8String]];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:@selector(runSpec)];
    
    [[KWExampleGroupBuilder sharedExampleGroupBuilder] startExampleGroups];
    [self buildExampleGroups];
    [[KWExampleGroupBuilder sharedExampleGroupBuilder] endExampleGroups];
    
    objc_setAssociatedObject(invocation, @"__KWExampleGroup", [[KWExampleGroupBuilder sharedExampleGroupBuilder] exampleGroup], OBJC_ASSOCIATION_RETAIN);
  
    return [NSArray arrayWithObject:invocation];
}

#pragma mark -
#pragma mark Visiting Nodes

- (void)visitContextNode:(KWContextNode *)aNode {
    [self.exampleNodeStack addObject:aNode];

    @try {
        [aNode.registerMatchersNode acceptExampleNodeVisitor:self];
        [aNode.beforeAllNode acceptExampleNodeVisitor:self];

        for (id<KWExampleNode> node in aNode.nodes)
            [node acceptExampleNodeVisitor:self];

        [aNode.afterAllNode acceptExampleNodeVisitor:self];
    } @catch (NSException *exception) {
        KWFailure *failure = [KWFailure failureWithCallSite:aNode.callSite format:@"%@ \"%@\" raised",
                                                                                  [exception name],
                                                                                  [exception reason]];
        [self reportFailure:failure];
    }

    [self.exampleNodeStack removeLastObject];
}

- (void)visitRegisterMatchersNode:(KWRegisterMatchersNode *)aNode {
    [self.exampleGroup.matcherFactory registerMatcherClassesWithNamespacePrefix:aNode.namespacePrefix];
}

- (void)visitBeforeAllNode:(KWBeforeAllNode *)aNode {
    if (aNode.block == nil)
        return;

    aNode.block();
}

- (void)visitAfterAllNode:(KWAfterAllNode *)aNode {
    if (aNode.block == nil)
        return;

    aNode.block();
}

- (void)visitBeforeEachNode:(KWBeforeEachNode *)aNode {
    if (aNode.block == nil)
        return;

    aNode.block();
}

- (void)visitAfterEachNode:(KWAfterEachNode *)aNode {
    if (aNode.block == nil)
        return;

    aNode.block();
}

- (void)visitItNode:(KWItNode *)aNode {
    if (aNode.block == nil)
        return;

    aNode.spec = self;

    @try {
        for (KWContextNode *contextNode in self.exampleNodeStack) {
            if (contextNode.beforeEachNode.block != nil)
                contextNode.beforeEachNode.block();
        }

        // Add it node to the stack
        [self.exampleNodeStack addObject:aNode];

        @try {
            aNode.block();

#if KW_TARGET_HAS_INVOCATION_EXCEPTION_BUG
            NSException *invocationException = KWGetAndClearExceptionFromAcrossInvocationBoundary();
            [invocationException raise];
#endif // #if KW_TARGET_HAS_INVOCATION_EXCEPTION_BUG

            // Finish verifying and clear
            for (id<KWVerifying> verifier in self.exampleGroup.verifiers) {
              [verifier exampleWillEnd];
            }

        } @catch (NSException *exception) {
            if (aNode.description == nil) {
              // anonymous specify blocks should only have one verifier, but use the first in any case
              aNode.description = [[self.exampleGroup.verifiers objectAtIndex:0] descriptionForAnonymousItNode];
            }

            KWFailure *failure = [KWFailure failureWithCallSite:aNode.callSite format:@"%@ \"%@\" raised",
                                                                                      [exception name],
                                                                                      [exception reason]];
            [self reportFailure:failure];
        }

        [self.exampleGroup.verifiers removeAllObjects];

        // Remove it node from the stack
        [self.exampleNodeStack removeLastObject];

        for (KWContextNode *contextNode in self.exampleNodeStack) {
            if (contextNode.afterEachNode.block != nil)
                contextNode.afterEachNode.block();
        }
    } @catch (NSException *exception) {
        KWFailure *failure = [KWFailure failureWithCallSite:aNode.callSite format:@"%@ \"%@\" raised",
                                                                                  [exception name],
                                                                                  [exception reason]];
        [self reportFailure:failure];
    }

    // Always clear stubs and spies at the end of it blocks
    KWClearAllMessageSpies();
    KWClearAllObjectStubs();
}

- (void)visitPendingNode:(KWPendingNode *)aNode {
    [self.exampleNodeStack addObject:aNode];
    NSLog(@"\"%@\" PENDING", [self descriptionForExampleContext]);
    [self.exampleNodeStack removeLastObject];
}

- (NSString *)generateDescriptionForAnonymousItNode
{
  return [[self.exampleGroup.verifiers objectAtIndex:0] descriptionForAnonymousItNode];
}

#pragma mark -
#pragma mark Running Specs

- (void)invokeTest 
{
    self.exampleGroup = objc_getAssociatedObject([self invocation], @"__KWExampleGroup");
    
    NSAutoreleasePool *subPool = [[NSAutoreleasePool alloc] init];
    
    @try {
        [self.exampleGroup runInSpec:self];
    } @catch (NSException *exception) {
        [self failWithException:exception];
    }
    
    [subPool release];
}

#pragma mark -
#pragma mark Class-level definition

+ (id)addVerifier:(id<KWVerifying>)aVerifier
{
  return [[[KWExampleGroupBuilder sharedExampleGroupBuilder] exampleGroup] addVerifier:aVerifier];
}

+ (id)addExistVerifierWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite
{
  return [[[KWExampleGroupBuilder sharedExampleGroupBuilder] exampleGroup] addExistVerifierWithExpectationType:anExpectationType callSite:aCallSite];
}

+ (id)addMatchVerifierWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite
{
  return [[[KWExampleGroupBuilder sharedExampleGroupBuilder] exampleGroup] addMatchVerifierWithExpectationType:anExpectationType callSite:aCallSite];
}

+ (id)addAsyncVerifierWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite timeout:(NSInteger)timeout
{
  return [[[KWExampleGroupBuilder sharedExampleGroupBuilder] exampleGroup] addAsyncVerifierWithExpectationType:anExpectationType callSite:aCallSite timeout:timeout];
}

@end
