//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"

#pragma mark -
#pragma mark Support Macros

#define KW_THIS_CALLSITE [KWCallSite callSiteWithFilename:@__FILE__ lineNumber:__LINE__]
#define KW_ADD_EXIST_VERIFIER(expectationType) [self addExistVerifierWithExpectationType:expectationType callSite:KW_THIS_CALLSITE]
#define KW_ADD_MATCH_VERIFIER(expectationType) [self addMatchVerifierWithExpectationType:expectationType callSite:KW_THIS_CALLSITE]
#define KW_ADD_ASYNC_VERIFIER(expectationType, timeOut) [self addAsyncVerifierWithExpectationType:expectationType callSite:KW_THIS_CALLSITE timeout:timeOut]

#pragma mark -
#pragma mark Keywords

// Kiwi macros used in specs for verifying expectations.
#define should attachToVerifier:KW_ADD_MATCH_VERIFIER(KWExpectationTypeShould) verifier:KW_ADD_EXIST_VERIFIER(KWExpectationTypeShould)
#define shouldNot attachToVerifier:KW_ADD_MATCH_VERIFIER(KWExpectationTypeShouldNot) verifier:KW_ADD_EXIST_VERIFIER(KWExpectationTypeShould)
#define shouldBeNil attachToVerifier:KW_ADD_EXIST_VERIFIER(KWExpectationTypeShouldNot)
#define shouldNotBeNil attachToVerifier:KW_ADD_EXIST_VERIFIER(KWExpectationTypeShould)
#define shouldEventually attachToVerifier:KW_ADD_ASYNC_VERIFIER(KWExpectationTypeShould, kKW_DEFAULT_PROBE_TIMEOUT)
#define shouldEventuallyBeforeTimingOutAfter(timeout) attachToVerifier:KW_ADD_ASYNC_VERIFIER(KWExpectationTypeShould, timeout)

// wait for is like a shouldEventually but will not fail if it's never satisfied
#define waitFor attachToVerifier:KW_ADD_ASYNC_VERIFIER(KWExpectationTypeMaybe, kKW_DEFAULT_PROBE_TIMEOUT)

// used to wrap a pointer to an object that will change in the future (used with shouldEventually)
#define theObject(objectPtr) [KWFutureObject objectWithObjectPointer:objectPtr]
#define theReturnValueOfBlock(block) [KWFutureObject objectWithReturnValueOfBlock:block]

#if KW_BLOCKS_ENABLED
    // Kiwi macros used in specs to create example groups. Because these macros
    // hide functions of the same name, they can be undefined at the expense of
    // getting call site information injected into output messages.
    #define describe(...) describeWithCallSite(KW_THIS_CALLSITE, __VA_ARGS__)
    #define context(...) contextWithCallSite(KW_THIS_CALLSITE, __VA_ARGS__)
    #define registerMatchers(...) registerMatchersWithCallSite(KW_THIS_CALLSITE, __VA_ARGS__)
    #define beforeAll(...) beforeAllWithCallSite(KW_THIS_CALLSITE, __VA_ARGS__)
    #define afterAll(...) afterAllWithCallSite(KW_THIS_CALLSITE, __VA_ARGS__)
    #define beforeEach(...) beforeEachWithCallSite(KW_THIS_CALLSITE, __VA_ARGS__)
    #define afterEach(...) afterEachWithCallSite(KW_THIS_CALLSITE, __VA_ARGS__)
    #define it(...) itWithCallSite(KW_THIS_CALLSITE, __VA_ARGS__)
    #define pending(...) pendingWithCallSite(KW_THIS_CALLSITE, __VA_ARGS__)
    #define xit(...) pendingWithCallSite(KW_THIS_CALLSITE, __VA_ARGS__)
#endif // #if KW_BLOCKS_ENABLED

// If a gcc compatible compiler is available, use the statement and
// declarations in expression extension to provide a convenient catch-all macro
// to create KWValues.
#if defined(__GNUC__)
    #define theValue(expr) \
        ({ \
            __typeof__(expr) kiwiReservedPrefix_lVar = expr; \
            [KWValue valueWithBytes:&kiwiReservedPrefix_lVar objCType:@encode(__typeof__(expr))]; \
        })
#endif // #if defined(__GNUC__)

#if KW_BLOCKS_ENABLED
// Example group declarations.
    #define SPEC_BEGIN(name) \
        \
        @interface name : KWSpec \
        \
        @end \
        \
        @implementation name \
        \
        - (void)buildExampleGroups { \

    #define SPEC_END \
        } \
        \
        @end
#endif // #if KW_BLOCKS_ENABLED
