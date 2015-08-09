//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "KiwiTestConfiguration.h"
#import "KWBlockNode.h"

#if KW_TESTS_ENABLED

@interface KWBlockNodeTest : XCTestCase
@end

@implementation KWBlockNodeTest

- (void)testDescription {
    KWBlockNode *node = [[KWBlockNode alloc] initWithCallSite:nil description:@"a description" block:nil];
    XCTAssertEqualObjects(@"a description", node.description, @"expected node description to be set by the initializer");
}

@end

#endif // #if KW_TESTS_ENABLED
