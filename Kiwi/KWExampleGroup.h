//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"
#import "KWBlock.h"

#if KW_BLOCKS_ENABLED

@class KWCallSite;

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

#endif // #if KW_BLOCKS_ENABLED
