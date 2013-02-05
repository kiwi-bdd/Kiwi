//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWExample.h"
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
#import "KWExampleSuite.h"


@interface KWExample ()

@property (nonatomic, readonly) NSMutableArray *verifiers;
@property (nonatomic, readonly) KWMatcherFactory *matcherFactory;
@property (nonatomic, assign) id<KWExampleDelegate> delegate;
@property (nonatomic, assign) BOOL didNotFinish;

- (void)reportResultForExampleNodeWithLabel:(NSString *)label;

@end

@implementation KWExample

@synthesize matcherFactory;
@synthesize verifiers;
@synthesize delegate = _delegate;
@synthesize suite;
@synthesize lastInContexts;
@synthesize didNotFinish;

- (id)initWithExampleNode:(id<KWExampleNode>)node
{
  if ((self = [super init])) {
    exampleNode = [node retain];
    matcherFactory = [[KWMatcherFactory alloc] init];
    verifiers = [[NSMutableArray alloc] init];
    lastInContexts = [[NSMutableArray alloc] init];
    passed = YES;
  }
  return self;
}

- (void)dealloc 
{
  [lastInContexts release];
  [exampleNode release];
  [matcherFactory release];
  [verifiers release];
  [super dealloc];
}

- (BOOL)isLastInContext:(KWContextNode *)context
{
  for (KWContextNode *contextWhereItLast in lastInContexts) {
    if (context == contextWhereItLast) {
      return YES;
    }
  }
  return NO;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"<KWExample: %@>", exampleNode.description];
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

- (void)runWithDelegate:(id<KWExampleDelegate>)delegate;
{
  self.delegate = delegate;
  [self.matcherFactory registerMatcherClassesWithNamespacePrefix:@"KW"];
  [[KWExampleGroupBuilder sharedExampleGroupBuilder] setCurrentExample:self];
  [exampleNode acceptExampleNodeVisitor:self]; 
}

#pragma mark - Reporting failure

- (NSString *)descriptionForExampleContext {
  NSMutableArray *parts = [NSMutableArray array];

  for (KWContextNode *context in [[exampleNode contextStack] reverseObjectEnumerator]) {
    if ([context description] != nil) {
      [parts addObject:[[context description] stringByAppendingString:@","]];
    }
  }
  
  return [parts componentsJoinedByString:@" "];
}

- (KWFailure *)outputReadyFailureWithFailure:(KWFailure *)aFailure {
  NSString *annotatedFailureMessage = [NSString stringWithFormat:@"'%@ %@' [FAILED], %@",
                                       [self descriptionForExampleContext], [exampleNode description],
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
  [self.delegate example:self didFailWithFailure:[self outputReadyFailureWithFailure:failure]];
}

- (void)reportResultForExampleNodeWithLabel:(NSString *)label
{
  NSLog(@"+ '%@ %@' [%@]", [self descriptionForExampleContext], [exampleNode description], label);
}

#pragma mark - Full description with context

/** Pending cases will be marked yellow by XCode as not finished, because their description differs for -[SenTestCaseRun start] and -[SenTestCaseRun stop] methods
 */

- (NSString *)pendingNotFinished {
    BOOL reportPending = self.didNotFinish;
    self.didNotFinish = YES;
    return reportPending ? @"(PENDING)" : @"";
}
    
- (NSString *)descriptionWithContext {
    NSString *descriptionWithContext = [NSString stringWithFormat:@"%@ %@", 
                                        [self descriptionForExampleContext], 
                                        [exampleNode description] ? [exampleNode description] : @""];
    BOOL isPending = [exampleNode isKindOfClass:[KWPendingNode class]];
    return isPending ? [descriptionWithContext stringByAppendingString:[self pendingNotFinished]] : descriptionWithContext;
}

#pragma mark - Visiting Nodes

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
  
  aNode.example = self;
  
  [aNode.context performExample:self withBlock:^{
  
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
    
    if (passed) {
      [self reportResultForExampleNodeWithLabel:@"PASSED"];
    }
    
    // Always clear stubs and spies at the end of it blocks
      KWClearStubsAndSpies();
  }];
}

- (void)visitPendingNode:(KWPendingNode *)aNode {
  if (aNode != exampleNode)
    return;

  [self reportResultForExampleNodeWithLabel:@"PENDING"];
}

- (NSString *)generateDescriptionForAnonymousItNode
{
  // anonymous specify blocks should only have one verifier, but use the first in any case
  return [(self.verifiers)[0] descriptionForAnonymousItNode];
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

void pending_(NSString *aDescription, KWVoidBlock ignoredBlock) {
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
