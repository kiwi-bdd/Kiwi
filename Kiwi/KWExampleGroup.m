//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWExampleGroup.h"
#import "KWExampleGroupBuilder.h"

#if KW_BLOCKS_ENABLED

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

#endif // #if KW_BLOCKS_ENABLED
