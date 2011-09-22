//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWExampleGroup.h"
#import "KWExampleGroupBuilder.h"
#import "KWContextNode.h"
#import "KWMatcherFactory.h"
#import "KWExistVerifier.h"
#import "KWMatchVerifier.h"
#import "KWAsyncVerifier.h"
#import "KWFailure.h"
#import "KWContextNode.h"
#import "KWBeforeEachNode.h"
#import "KWBeforeAllNode.h"
#import "KWItNode.h"
#import "KWAfterEachNode.h"
#import "KWAfterAllNode.h"
#import "KWPendingNode.h"
#import "KWRegisterMatchersNode.h"
#import "KWWorkarounds.h"
#import "KWIntercept.h"
#import "KWExampleNode.h"


@interface KWExampleGroup ()

@property (nonatomic, readonly) NSMutableArray *verifiers;
@property (nonatomic, readonly) KWMatcherFactory *matcherFactory;
@property (nonatomic, readonly) NSMutableArray *exampleNodeStack;
@property (nonatomic, assign) id<KWExampleGroupDelegate> delegate;

@end

@implementation KWExampleGroup

@synthesize matcherFactory;
@synthesize verifiers;
@synthesize exampleNodeStack;
@synthesize delegate = _delegate;

- (id)initWithExampleNode:(id<KWExampleNode>)node contextNodeStack:(NSArray *)stack;
{
  if ((self = [super init])) {
    contextNodeStack = [stack copy];
    exampleNode = [node retain];
    matcherFactory = [[KWMatcherFactory alloc] init];
    verifiers = [[NSMutableArray alloc] init];
    exampleNodeStack = [[NSMutableArray alloc] init];
    passed = YES;
  }
  return self;
}

- (void)dealloc 
{
  [contextNodeStack release];
  [exampleNode release];
  [exampleNodeStack release];
  [matcherFactory release];
  [verifiers release];
  [super dealloc];
}

#pragma mark - Adding Verifiers

- (id)addVerifier:(id<KWVerifying>)aVerifier {
  if (![self.verifiers containsObject:aVerifier])
    [self.verifiers addObject:aVerifier];
  
  return aVerifier;
}

- (id)addExistVerifierWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite {
  id verifier = [KWExistVerifier existVerifierWithExpectationType:anExpectationType callSite:aCallSite reporter:self];
  [self addVerifier:verifier];
  return verifier;
}

- (id)addMatchVerifierWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite {
  id verifier = [KWMatchVerifier matchVerifierWithExpectationType:anExpectationType callSite:aCallSite matcherFactory:self.matcherFactory reporter:self];
  [self addVerifier:verifier];
  return verifier;
}

- (id)addAsyncVerifierWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite timeout:(NSInteger)timeout {
  id verifier = [KWAsyncVerifier asyncVerifierWithExpectationType:anExpectationType callSite:aCallSite matcherFactory:self.matcherFactory reporter:self probeTimeout:timeout];
  [self addVerifier:verifier];
  return verifier;
}

#pragma mark - Running examples

- (void)runWithDelegate:(id<KWExampleGroupDelegate>)delegate;
{
  self.delegate = delegate;
  [self.matcherFactory registerMatcherClassesWithNamespacePrefix:@"KW"];
  [[KWExampleGroupBuilder sharedExampleGroupBuilder] setCurrentExampleGroup:self];
  [[contextNodeStack objectAtIndex:0] acceptExampleNodeVisitor:self];
}

#pragma mark - Reporting failure

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
  NSString *annotatedFailureMessage = [NSString stringWithFormat:@"'%@' [FAILED], %@",
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

- (void)reportFailure:(KWFailure *)failure
{
  passed = NO;
  [self.delegate exampleGroup:self didFailWithFailure:[self outputReadyFailureWithFailure:failure]];
}

#pragma mark - Visiting Nodes

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
  [self.matcherFactory registerMatcherClassesWithNamespacePrefix:aNode.namespacePrefix];
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
  if (aNode.block == nil || aNode != exampleNode)
    return;
  
  aNode.exampleGroup = self;
  
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
      for (id<KWVerifying> verifier in self.verifiers) {
        [verifier exampleWillEnd];
      }
      
    } @catch (NSException *exception) {      
      KWFailure *failure = [KWFailure failureWithCallSite:aNode.callSite format:@"%@ \"%@\" raised",
                            [exception name],
                            [exception reason]];
      [self reportFailure:failure];
    }

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
  
  if (passed) {
    NSLog(@"+ '%@ %@' [PASSED]", [self descriptionForExampleContext], [exampleNode description]);
  }
  
  // Always clear stubs and spies at the end of it blocks
  KWClearAllMessageSpies();
  KWClearAllObjectStubs();
}

- (void)visitPendingNode:(KWPendingNode *)aNode {
  if (aNode != exampleNode)
    return;
  
  [self.exampleNodeStack addObject:aNode];
  NSLog(@"+ '%@' [PENDING]", [self descriptionForExampleContext]);
  [self.exampleNodeStack removeLastObject];
}

- (NSString *)generateDescriptionForAnonymousItNode
{
  // anonymous specify blocks should only have one verifier, but use the first in any case
  return [[self.verifiers objectAtIndex:0] descriptionForAnonymousItNode];
}

@end

#pragma mark -
#pragma mark Building Example Groups

void describe(NSString *aDescription, KWVoidBlock aBlock) {
    describeWithCallSite(nil, aDescription, aBlock);
}

void context(NSString *aDescription, KWVoidBlock aBlock) {
    contextWithCallSite(nil, aDescription, aBlock);
}

void registerMatchers(NSString *aNamespacePrefix) {
    registerMatchersWithCallSite(nil, aNamespacePrefix);
}

void beforeAll(KWVoidBlock aBlock) {
    beforeAllWithCallSite(nil, aBlock);
}

void afterAll(KWVoidBlock aBlock) {
    afterAllWithCallSite(nil, aBlock);
}

void beforeEach(KWVoidBlock aBlock) {
    beforeEachWithCallSite(nil, aBlock);
}

void afterEach(KWVoidBlock aBlock) {
    afterEachWithCallSite(nil, aBlock);
}

void it(NSString *aDescription, KWVoidBlock aBlock) {
    itWithCallSite(nil, aDescription, aBlock);
}

void specify(KWVoidBlock aBlock)
{
    itWithCallSite(nil, nil, aBlock);
}

void pending(NSString *aDescription, KWVoidBlock ignoredBlock) {
    pendingWithCallSite(nil, aDescription, ignoredBlock);
}

void describeWithCallSite(KWCallSite *aCallSite, NSString *aDescription, KWVoidBlock aBlock) {
    contextWithCallSite(aCallSite, aDescription, aBlock);
}

void contextWithCallSite(KWCallSite *aCallSite, NSString *aDescription, KWVoidBlock aBlock) {
    [[KWExampleGroupBuilder sharedExampleGroupBuilder] pushContextNodeWithCallSite:aCallSite description:aDescription];
    aBlock();
    [[KWExampleGroupBuilder sharedExampleGroupBuilder] popContextNode];
}

void registerMatchersWithCallSite(KWCallSite *aCallSite, NSString *aNamespacePrefix) {
    [[KWExampleGroupBuilder sharedExampleGroupBuilder] setRegisterMatchersNodeWithCallSite:aCallSite namespacePrefix:aNamespacePrefix];
}

void beforeAllWithCallSite(KWCallSite *aCallSite, KWVoidBlock aBlock) {
    [[KWExampleGroupBuilder sharedExampleGroupBuilder] setBeforeAllNodeWithCallSite:aCallSite block:aBlock];
}

void afterAllWithCallSite(KWCallSite *aCallSite, KWVoidBlock aBlock) {
    [[KWExampleGroupBuilder sharedExampleGroupBuilder] setAfterAllNodeWithCallSite:aCallSite block:aBlock];
}

void beforeEachWithCallSite(KWCallSite *aCallSite, KWVoidBlock aBlock) {
    [[KWExampleGroupBuilder sharedExampleGroupBuilder] setBeforeEachNodeWithCallSite:aCallSite block:aBlock];
}

void afterEachWithCallSite(KWCallSite *aCallSite, KWVoidBlock aBlock) {
    [[KWExampleGroupBuilder sharedExampleGroupBuilder] setAfterEachNodeWithCallSite:aCallSite block:aBlock];
}

void itWithCallSite(KWCallSite *aCallSite, NSString *aDescription, KWVoidBlock aBlock) {
    [[KWExampleGroupBuilder sharedExampleGroupBuilder] addItNodeWithCallSite:aCallSite description:aDescription block:aBlock];
}

void pendingWithCallSite(KWCallSite *aCallSite, NSString *aDescription, KWVoidBlock ignoredBlock) {
    [[KWExampleGroupBuilder sharedExampleGroupBuilder] addPendingNodeWithCallSite:aCallSite description:aDescription];
}
