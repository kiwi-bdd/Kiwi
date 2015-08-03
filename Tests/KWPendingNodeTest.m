//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "KiwiTestConfiguration.h"
#import "KWPendingNode.h"

#if KW_TESTS_ENABLED

@interface KWPendingNodeTest : XCTestCase

@end

@implementation KWPendingNodeTest

- (void)testDescription {
    KWPendingNode *node = [[KWPendingNode alloc] initWithCallSite:nil context:nil description:@"a description"];
    XCTAssertEqualObjects(@"a description", node.description, @"expected node description to be set by the initializer");
}

@end

#endif // KW_TESTS_ENABLED
