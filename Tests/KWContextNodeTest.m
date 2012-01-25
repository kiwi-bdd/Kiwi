//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWContextNodeTest : SenTestCase

@end

@implementation KWContextNodeTest

- (void)testItShouldAllowOnlyOneBeforeEachBlock {
    KWContextNode *node = [KWContextNode contextNodeWithCallSite:nil parentContext:nil description:nil];
    __block NSUInteger tag = 0;
    KWVoidBlock block = ^{ ++tag; };
    [node setBeforeEachNode:[KWBeforeEachNode beforeEachNodeWithCallSite:nil block:block]];
    STAssertThrows([node setBeforeEachNode:[KWBeforeEachNode beforeEachNodeWithCallSite:nil block:block]], @"expected exception");
}

- (void)testItShouldAllowOnlyOneAfterEachBlock {
    KWContextNode *node = [KWContextNode contextNodeWithCallSite:nil parentContext:nil description:nil];
    __block NSUInteger tag = 0;
    KWVoidBlock block = ^{ ++tag; };
    [node setAfterEachNode:[KWAfterEachNode afterEachNodeWithCallSite:nil block:block]];
    STAssertThrows([node setAfterEachNode:[KWAfterEachNode afterEachNodeWithCallSite:nil block:block]], @"expected exception");
}

@end

#endif // #if KW_TESTS_ENABLED
