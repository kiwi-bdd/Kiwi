//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWExampleGroup.h"
#import "KWExampleGroupBuilder.h"
#import "KWContextNode.h"
#import "KWSpec.h"
#import "KWMatcherFactory.h"
#import "KWExistVerifier.h"
#import "KWMatchVerifier.h"
#import "KWAsyncVerifier.h"

@interface KWExampleGroup ()

@property (nonatomic, retain) KWSpec *spec;

@end

@implementation KWExampleGroup {
  KWContextNode *rootNode;
}

@synthesize matcherFactory;
@synthesize verifiers;
@synthesize spec = _spec;

- (id)initWithRootContextNode:(KWContextNode *)node
{
  if ((self = [super init])) {
    rootNode = [node retain];
    matcherFactory = [[KWMatcherFactory alloc] init];
    verifiers = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)dealloc 
{
  [_spec release];
  [matcherFactory release];
  [verifiers release];
  [rootNode release];
  [super dealloc];
}

#pragma mark - Adding Verifiers

- (id)addVerifier:(id<KWVerifying>)aVerifier {
  if (![self.verifiers containsObject:aVerifier])
    [self.verifiers addObject:aVerifier];
  
  return aVerifier;
}

- (id)addExistVerifierWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite {
  id verifier = [KWExistVerifier existVerifierWithExpectationType:anExpectationType callSite:aCallSite reporter:self.spec];
  [self addVerifier:verifier];
  return verifier;
}

- (id)addMatchVerifierWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite {
  id verifier = [KWMatchVerifier matchVerifierWithExpectationType:anExpectationType callSite:aCallSite matcherFactory:self.matcherFactory reporter:self.spec];
  [self addVerifier:verifier];
  return verifier;
}

- (id)addAsyncVerifierWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite timeout:(NSInteger)timeout {
  id verifier = [KWAsyncVerifier asyncVerifierWithExpectationType:anExpectationType callSite:aCallSite matcherFactory:self.matcherFactory reporter:self.spec probeTimeout:timeout];
  [self addVerifier:verifier];
  return verifier;
}

#pragma mark - Running examples

- (void)runInSpec:(KWSpec *)spec
{
  self.spec = spec;
  
  [self.matcherFactory registerMatcherClassesWithNamespacePrefix:@"KW"];
  [rootNode acceptExampleNodeVisitor:spec];
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
