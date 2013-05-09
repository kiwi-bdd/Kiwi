//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"
#import "KWBlock.h"
#import "KWVerifying.h"
#import "KWExpectationType.h"
#import "KWExampleNode.h"
#import "KWExampleNodeVisitor.h"
#import "KWReporting.h"
#import "KWExampleGroupDelegate.h"

@class KWCallSite;
@class KWExampleSuite;
@class KWContextNode;
@class KWSpec;
@class KWMatcherFactory;

@interface KWExample : NSObject <KWExampleNodeVisitor, KWReporting>

@property (nonatomic, retain, readonly) NSMutableArray *lastInContexts;
@property (nonatomic, assign) KWExampleSuite *suite;

- (id)initWithExampleNode:(id<KWExampleNode>)node;

#pragma mark - Adding Verifiers

- (id)addVerifier:(id<KWVerifying>)aVerifier;
- (id)addExistVerifierWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite;
- (id)addMatchVerifierWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite;
- (id)addAsyncVerifierWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite timeout:(NSInteger)timeout;

#pragma mark - Report failure

- (void)reportFailure:(KWFailure *)failure;

#pragma mark - Running

- (void)runWithDelegate:(id<KWExampleDelegate>)delegate;

#pragma mark - Anonymous It Node Descriptions

- (NSString *)generateDescriptionForAnonymousItNode;

#pragma mark - Checking if last in context

- (BOOL)isLastInContext:(KWContextNode *)context;

#pragma mark - Full description with context

- (NSString *)descriptionWithContext;

@end

#pragma mark - Building Example Groups

void describe(NSString *aDescription, KWVoidBlock aBlock);
void context(NSString *aDescription, KWVoidBlock aBlock);
void registerMatchers(NSString *aNamespacePrefix);
void beforeAll(KWVoidBlock aBlock);
void afterAll(KWVoidBlock aBlock);
void beforeEach(KWVoidBlock aBlock);
void afterEach(KWVoidBlock aBlock);
void it(NSString *aDescription, KWVoidBlock aBlock);
void specify(KWVoidBlock aBlock);
void pending_(NSString *aDescription, KWVoidBlock ignoredBlock);

void describeWithCallSite(KWCallSite *aCallSite, NSString *aDescription, KWVoidBlock aBlock);
void contextWithCallSite(KWCallSite *aCallSite, NSString *aDescription, KWVoidBlock aBlock);
void registerMatchersWithCallSite(KWCallSite *aCallSite, NSString *aNamespacePrefix);
void beforeAllWithCallSite(KWCallSite *aCallSite, KWVoidBlock aBlock);
void afterAllWithCallSite(KWCallSite *aCallSite, KWVoidBlock aBlock);
void beforeEachWithCallSite(KWCallSite *aCallSite, KWVoidBlock aBlock);
void afterEachWithCallSite(KWCallSite *aCallSite, KWVoidBlock aBlock);
void itWithCallSite(KWCallSite *aCallSite, NSString *aDescription, KWVoidBlock aBlock);
void pendingWithCallSite(KWCallSite *aCallSite, NSString *aDescription, KWVoidBlock ignoredBlock);

#define PRAGMA(x) _Pragma (#x)
#define PENDING(x) PRAGMA(message ( "Pending: " #x ))

#define pending(title, args...) \
PENDING(title) \
pending_(title, ## args)
#define xit(title, args...) \
PENDING(title) \
pending_(title, ## args)
