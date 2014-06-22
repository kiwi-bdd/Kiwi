//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"
#import "KWLetNode.h"

#if KW_TESTS_ENABLED

@interface KWContextNodeTest : XCTestCase

@end

@implementation KWContextNodeTest

- (void)testItShouldAllowOnlyOneBeforeEachBlock {
    KWContextNode *node = [KWContextNode contextNodeWithCallSite:nil parentContext:nil description:nil];
    __block NSUInteger tag = 0;
    void (^block)(void) = ^{ ++tag; };
    [node setBeforeEachNode:[KWBeforeEachNode beforeEachNodeWithCallSite:nil block:block]];
    XCTAssertThrows([node setBeforeEachNode:[KWBeforeEachNode beforeEachNodeWithCallSite:nil block:block]], @"expected exception");
}

- (void)testItShouldAllowOnlyOneAfterEachBlock {
    KWContextNode *node = [KWContextNode contextNodeWithCallSite:nil parentContext:nil description:nil];
    __block NSUInteger tag = 0;
    void (^block)(void) = ^{ ++tag; };
    [node setAfterEachNode:[KWAfterEachNode afterEachNodeWithCallSite:nil block:block]];
    XCTAssertThrows([node setAfterEachNode:[KWAfterEachNode afterEachNodeWithCallSite:nil block:block]], @"expected exception");
}

#pragma mark - Context registerMatchers nodes

- (void)testItAddsNewRegisterMatchersNodesToAnArray {
    KWRegisterMatchersNode *nodeAbc = [[KWRegisterMatchersNode alloc] initWithCallSite:nil
                                                                       namespacePrefix:@"ABC"];
    KWRegisterMatchersNode *nodeXyz = [[KWRegisterMatchersNode alloc] initWithCallSite:nil
                                                                       namespacePrefix:@"XYZ"];
    KWContextNode *context = [KWContextNode contextNodeWithCallSite:nil
                                                      parentContext:nil
                                                        description:nil];
    [context addRegisterMatchersNode:nodeAbc];
    [context addRegisterMatchersNode:nodeXyz];

    NSArray *expectedRegisterMatchersNodes = @[nodeAbc, nodeXyz];
    XCTAssertEqualObjects(context.registerMatchersNodes,
                          expectedRegisterMatchersNodes,
                          @"register matchers nodes not stored in the order they were added");
}

#pragma mark - Context let nodes

- (void)testItAddsNewLetNodesToAnArray {
    KWLetNode *letNode1 = [KWLetNode letNodeWithSymbolName:nil objectRef:nil block:nil];
    KWLetNode *letNode2 = [KWLetNode letNodeWithSymbolName:nil objectRef:nil block:nil];
    KWContextNode *context = [KWContextNode contextNodeWithCallSite:nil parentContext:nil description:nil];
    [context addLetNode:letNode1];
    [context addLetNode:letNode2];
    NSArray *expectedLetNodes = [NSArray arrayWithObjects:letNode1, letNode2, nil];
    XCTAssertEqualObjects(context.letNodes, expectedLetNodes, @"expected an array of let nodes in the order they were added");
}

- (void)testNewLetNodesHaveNoRelationships {
    KWLetNode *letNode1 = [KWLetNode letNodeWithSymbolName:@"symbol" objectRef:nil block:nil];
    KWLetNode *letNode2 = [KWLetNode letNodeWithSymbolName:@"symbol" objectRef:nil block:nil];
    KWContextNode *context = [KWContextNode contextNodeWithCallSite:nil parentContext:nil description:nil];
    [context addLetNode:letNode1];
    [context addLetNode:letNode2];
    XCTAssertNil(letNode1.child, @"expected first let node to have no child");
    XCTAssertNil(letNode1.next, @"expected first let node to have no next node");
    XCTAssertNil(letNode1.parent, @"expected first let node to have no parent");
    XCTAssertNil(letNode1.previous, @"expected first let node to have no previous node");
    XCTAssertNil(letNode2.child, @"expected second let node to have no child");
    XCTAssertNil(letNode2.next, @"expected second let node to have no next node");
    XCTAssertNil(letNode2.parent, @"expected second let node to have no parent");
    XCTAssertNil(letNode2.previous, @"expected second let node to have no previous node");
}

- (void)testItBuildsATreeOfItsLetNodesWithoutAParentContext {
    KWLetNode *letNode1 = [KWLetNode letNodeWithSymbolName:@"symbol1" objectRef:nil block:nil];
    KWLetNode *letNode2 = [KWLetNode letNodeWithSymbolName:@"symbol2" objectRef:nil block:nil];
    KWContextNode *context = [KWContextNode contextNodeWithCallSite:nil parentContext:nil description:nil];
    [context addLetNode:letNode1];
    [context addLetNode:letNode2];
    KWLetNode *tree = [context letNodeTree];
    XCTAssertEqualObjects(tree, letNode1, @"expected the root of the tree to be the first let node");
    XCTAssertEqualObjects(tree.next, letNode2, @"expected the root's next node to be the second let node");
}

- (void)testItBuildsATreeBasedOnItsParentsTreeWithAParentContext {
    KWLetNode *letNode1 = [KWLetNode letNodeWithSymbolName:@"symbol1" objectRef:nil block:nil];
    KWLetNode *letNode2 = [KWLetNode letNodeWithSymbolName:@"symbol2" objectRef:nil block:nil];
    KWContextNode *context1 = [KWContextNode contextNodeWithCallSite:nil parentContext:nil description:@"context1"];
    [context1 addLetNode:letNode1];
    [context1 addLetNode:letNode2];

    KWLetNode *letNode3 = [KWLetNode letNodeWithSymbolName:@"symbol1" objectRef:nil block:nil];
    KWContextNode *context2 = [KWContextNode contextNodeWithCallSite:nil parentContext:context1 description:@"context2"];
    [context2 addLetNode:letNode3];
    [context1 addContextNode:context2];

    KWLetNode *tree = [context2 letNodeTree];
    XCTAssertEqualObjects(tree, letNode1, @"expected the root of the tree to be the first let node");
    XCTAssertEqualObjects(tree.next, letNode2, @"expected the root's next node to be the second let node");
    XCTAssertEqualObjects(tree.child, letNode3, @"expected the root's child node to be the third let node");
}

@end

#endif // #if KW_TESTS_ENABLED
