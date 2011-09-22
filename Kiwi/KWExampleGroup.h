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
@class KWContextNode;
@class KWSpec;
@class KWMatcherFactory;

@interface KWExampleGroup : NSObject <KWExampleNodeVisitor, KWReporting> {
@private
    NSArray *contextNodeStack;
    id<KWExampleNode> exampleNode;
    BOOL passed;
}

- (id)initWithExampleNode:(id<KWExampleNode>)node contextNodeStack:(NSArray *)stack;

#pragma mark - Adding Verifiers

- (id)addVerifier:(id<KWVerifying>)aVerifier;
- (id)addExistVerifierWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite;
- (id)addMatchVerifierWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite;
- (id)addAsyncVerifierWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite timeout:(NSInteger)timeout;

#pragma mark - Running

- (void)runWithDelegate:(id<KWExampleGroupDelegate>)delegate;

#pragma mark -
#pragma mark Anonymous It Node Descriptions

- (NSString *)generateDescriptionForAnonymousItNode;

@end

#pragma mark -
#pragma mark Building Example Groups

void describe(NSString *aDescription, KWVoidBlock aBlock);
void context(NSString *aDescription, KWVoidBlock aBlock);
void registerMatchers(NSString *aNamespacePrefix);
void beforeAll(KWVoidBlock aBlock);
void afterAll(KWVoidBlock aBlock);
void beforeEach(KWVoidBlock aBlock);
void afterEach(KWVoidBlock aBlock);
void it(NSString *aDescription, KWVoidBlock aBlock);
void specify(KWVoidBlock aBlock);
void pending(NSString *aDescription, KWVoidBlock ignoredBlock);

void describeWithCallSite(KWCallSite *aCallSite, NSString *aDescription, KWVoidBlock aBlock);
void contextWithCallSite(KWCallSite *aCallSite, NSString *aDescription, KWVoidBlock aBlock);
void registerMatchersWithCallSite(KWCallSite *aCallSite, NSString *aNamespacePrefix);
void beforeAllWithCallSite(KWCallSite *aCallSite, KWVoidBlock aBlock);
void afterAllWithCallSite(KWCallSite *aCallSite, KWVoidBlock aBlock);
void beforeEachWithCallSite(KWCallSite *aCallSite, KWVoidBlock aBlock);
void afterEachWithCallSite(KWCallSite *aCallSite, KWVoidBlock aBlock);
void itWithCallSite(KWCallSite *aCallSite, NSString *aDescription, KWVoidBlock aBlock);
void pendingWithCallSite(KWCallSite *aCallSite, NSString *aDescription, KWVoidBlock ignoredBlock);

#define xit(...) pending(__VA_ARGS__)
