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
#import "KWCallSite.h"
#import "KWSymbolicator.h"

@interface KWExample () {
    id<KWExampleNode> exampleNode;
    BOOL passed;
}

@property (nonatomic, readonly) NSMutableArray *verifiers;
@property (nonatomic, readonly) KWMatcherFactory *matcherFactory;
@property (nonatomic, weak) id<KWExampleDelegate> delegate;
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
    exampleNode = node;
    matcherFactory = [[KWMatcherFactory alloc] init];
    verifiers = [[NSMutableArray alloc] init];
    lastInContexts = [[NSMutableArray alloc] init];
    passed = YES;
  }
  return self;
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
    if (self.unassignedVerifier) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                       reason:@"Trying to add another verifier without specifying a matcher for the previous one."
                                     userInfo:nil];
    }
    id<KWVerifying> verifier = [KWMatchVerifier matchVerifierWithExpectationType:anExpectationType callSite:aCallSite matcherFactory:self.matcherFactory reporter:self];
    [self addVerifier:verifier];
    self.unassignedVerifier = verifier;
    return verifier;
}

- (id)addAsyncVerifierWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite timeout:(NSInteger)timeout shouldWait:(BOOL)shouldWait {
  id verifier = [KWAsyncVerifier asyncVerifierWithExpectationType:anExpectationType callSite:aCallSite matcherFactory:self.matcherFactory reporter:self probeTimeout:timeout shouldWait: shouldWait];
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

#pragma mark - Looking up CallSites

KWCallSite *callSiteWithAddress(long address);
KWCallSite *callSiteAtAddressIfNecessary(long address);

KWCallSite *callSiteAtAddressIfNecessary(long address){
    BOOL shouldLookup = [[KWExampleGroupBuilder sharedExampleGroupBuilder] isFocused] && ![[KWExampleGroupBuilder sharedExampleGroupBuilder] foundFocus];
    return  shouldLookup ? callSiteWithAddress(address) : nil;
}

KWCallSite *callSiteWithAddress(long address){
    NSArray *args =@[@"-p", @(getpid()).stringValue, [NSString stringWithFormat:@"%lx", address]];
    NSString *callSite = [NSString stringWithShellCommand:@"/usr/bin/atos" arguments:args];

    NSString *pattern = @".+\\((.+):([0-9]+)\\)";
    NSError *e;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&e];
    NSArray *res = [regex matchesInString:callSite options:0 range:NSMakeRange(0, callSite.length)];

    NSString *fileName = nil;
    NSInteger lineNumber = 0;

    for (NSTextCheckingResult *ntcr in res) {
        fileName = [callSite substringWithRange:[ntcr rangeAtIndex:1]];
        NSString *lineNumberMatch = [callSite substringWithRange:[ntcr rangeAtIndex:2]];
        lineNumber = lineNumberMatch.integerValue;
    }
    return [KWCallSite callSiteWithFilename:fileName lineNumber:lineNumber];
}

#pragma mark - Building Example Groups

void describe(NSString *aDescription, void (^block)(void)) {
    KWCallSite *callSite = callSiteAtAddressIfNecessary(kwCallerAddress());
    describeWithCallSite(callSite, aDescription, block);
}

void context(NSString *aDescription, void (^block)(void)) {
    KWCallSite *callSite = callSiteAtAddressIfNecessary(kwCallerAddress());
    contextWithCallSite(callSite, aDescription, block);
}

void registerMatchers(NSString *aNamespacePrefix) {
    registerMatchersWithCallSite(nil, aNamespacePrefix);
}

void beforeAll(void (^block)(void)) {
    beforeAllWithCallSite(nil, block);
}

void afterAll(void (^block)(void)) {
    afterAllWithCallSite(nil, block);
}

void beforeEach(void (^block)(void)) {
    beforeEachWithCallSite(nil, block);
}

void afterEach(void (^block)(void)) {
    afterEachWithCallSite(nil, block);
}

void it(NSString *aDescription, void (^block)(void)) {
    KWCallSite *callSite = callSiteAtAddressIfNecessary(kwCallerAddress());
    itWithCallSite(callSite, aDescription, block);
}

void specify(void (^block)(void))
{
    itWithCallSite(nil, nil, block);
}

void pending_(NSString *aDescription, void (^ignoredBlock)(void)) {
    pendingWithCallSite(nil, aDescription, ignoredBlock);
}

void describeWithCallSite(KWCallSite *aCallSite, NSString *aDescription, void (^block)(void)) {

    contextWithCallSite(aCallSite, aDescription, block);
}

void contextWithCallSite(KWCallSite *aCallSite, NSString *aDescription, void (^block)(void)) {
    [[KWExampleGroupBuilder sharedExampleGroupBuilder] pushContextNodeWithCallSite:aCallSite description:aDescription];
    block();
    [[KWExampleGroupBuilder sharedExampleGroupBuilder] popContextNode];
}

void registerMatchersWithCallSite(KWCallSite *aCallSite, NSString *aNamespacePrefix) {
    [[KWExampleGroupBuilder sharedExampleGroupBuilder] setRegisterMatchersNodeWithCallSite:aCallSite namespacePrefix:aNamespacePrefix];
}

void beforeAllWithCallSite(KWCallSite *aCallSite, void (^block)(void)) {
    [[KWExampleGroupBuilder sharedExampleGroupBuilder] setBeforeAllNodeWithCallSite:aCallSite block:block];
}

void afterAllWithCallSite(KWCallSite *aCallSite, void (^block)(void)) {
    [[KWExampleGroupBuilder sharedExampleGroupBuilder] setAfterAllNodeWithCallSite:aCallSite block:block];
}

void beforeEachWithCallSite(KWCallSite *aCallSite, void (^block)(void)) {
    [[KWExampleGroupBuilder sharedExampleGroupBuilder] setBeforeEachNodeWithCallSite:aCallSite block:block];
}

void afterEachWithCallSite(KWCallSite *aCallSite, void (^block)(void)) {
    [[KWExampleGroupBuilder sharedExampleGroupBuilder] setAfterEachNodeWithCallSite:aCallSite block:block];
}

void itWithCallSite(KWCallSite *aCallSite, NSString *aDescription, void (^block)(void)) {
    [[KWExampleGroupBuilder sharedExampleGroupBuilder] addItNodeWithCallSite:aCallSite description:aDescription block:block];
}

void pendingWithCallSite(KWCallSite *aCallSite, NSString *aDescription, void (^ignoredBlock)(void)) {
    [[KWExampleGroupBuilder sharedExampleGroupBuilder] addPendingNodeWithCallSite:aCallSite description:aDescription];
}
