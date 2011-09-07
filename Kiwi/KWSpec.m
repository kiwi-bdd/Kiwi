//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWSpec.h"
#import <objc/runtime.h>
#import "KWExampleGroup.h"
#import "KWExampleGroupBuilder.h"
#import "KWIntercept.h"
#import "KWObjCUtilities.h"
#import "KWStringUtilities.h"
#import "NSMethodSignature+KiwiAdditions.h"
#import "KWFailure.h"

#define kKWINVOCATION_EXAMPLE_GROUP_KEY @"__KWExampleGroupKey"

@interface KWSpec()

#pragma mark -
#pragma mark Properties

@property (nonatomic, retain) KWExampleGroup *exampleGroup;

@end

@implementation KWSpec

@synthesize exampleGroup;

- (void)dealloc 
{
    objc_setAssociatedObject([self invocation], kKWINVOCATION_EXAMPLE_GROUP_KEY, nil, OBJC_ASSOCIATION_RETAIN);
    [exampleGroup release];
    [super dealloc];
}

+ (void)buildExampleGroups {
}

#pragma mark - Reporting Failure

- (void)reportFailure:(KWFailure *)failure
{
    [self failWithException:[failure exceptionValue]];
}

#pragma mark -
#pragma mark Getting Invocations

/* Called by the SenTestingKit test suite to get an array of invocations that
   should be run on instances of test cases. */

+ (NSArray *)testInvocations 
{
    SEL selector = @selector(buildExampleGroups);

    // Only return invocation if the receiver is a concrete spec that has overridden -buildExampleGroups.
    if ([self methodForSelector:selector] == [KWSpec methodForSelector:selector])
        return nil;
    
    [[KWExampleGroupBuilder sharedExampleGroupBuilder] startExampleGroups];
    [self buildExampleGroups];
    [[KWExampleGroupBuilder sharedExampleGroupBuilder] endExampleGroups];
    
    KWExampleGroup *exampleGroup = [[KWExampleGroupBuilder sharedExampleGroupBuilder] exampleGroup];
    
    // Add a single dummy invocation for the example group
    NSMethodSignature *methodSignature = [NSMethodSignature signatureWithObjCTypes:[KWEncodingForVoidMethod() UTF8String]];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
    [invocation setSelector:@selector(runSpec)];
    
    
    // because SenTest will modify the invocation target, we'll have to store 
    // another reference to the example group so we can retrieve it later
    objc_setAssociatedObject(invocation, kKWINVOCATION_EXAMPLE_GROUP_KEY, exampleGroup, OBJC_ASSOCIATION_RETAIN);
  
    return [NSArray arrayWithObject:invocation];
}

#pragma mark -
#pragma mark Running Specs

- (void)invokeTest 
{
    self.exampleGroup = objc_getAssociatedObject([self invocation], kKWINVOCATION_EXAMPLE_GROUP_KEY);
    
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
