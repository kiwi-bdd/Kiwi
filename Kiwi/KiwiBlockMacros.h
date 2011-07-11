//
//  KiwiBuilderMacros.h
//  Kiwi
//
//  Created by Luke Redpath on 11/07/2011.
//  Copyright 2011 Allen Ding. All rights reserved.
//

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

// user defined matchers
#define registerMatcher(name) \
\
@interface NSObject (KWUserDefinedMatchersDefinitions) \
- (void)name; \
@end \

#define defineMatcher(...) KWDefineMatchers(__VA_ARGS__)
#endif // #if KW_BLOCKS_ENABLED

