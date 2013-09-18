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

@interface KWContextNodeTest : SenTestCase

@end

@implementation KWContextNodeTest

- (void)testItShouldAllowOnlyOneBeforeEachBlock {
    KWContextNode *node = [KWContextNode contextNodeWithCallSite:nil parentContext:nil description:nil];
    __block NSUInteger tag = 0;
    void (^block)(void) = ^{ ++tag; };
    [node setBeforeEachNode:[KWBeforeEachNode beforeEachNodeWithCallSite:nil block:block]];
    STAssertThrows([node setBeforeEachNode:[KWBeforeEachNode beforeEachNodeWithCallSite:nil block:block]], @"expected exception");
}

- (void)testItShouldAllowOnlyOneAfterEachBlock {
    KWContextNode *node = [KWContextNode contextNodeWithCallSite:nil parentContext:nil description:nil];
    __block NSUInteger tag = 0;
    void (^block)(void) = ^{ ++tag; };
    [node setAfterEachNode:[KWAfterEachNode afterEachNodeWithCallSite:nil block:block]];
    STAssertThrows([node setAfterEachNode:[KWAfterEachNode afterEachNodeWithCallSite:nil block:block]], @"expected exception");
}

#pragma mark - Context let nodes

- (void)testItAddsNewLetNodesToAnArray {
    KWLetNode *letNode1 = [KWLetNode letNodeWithSymbolName:nil objectRef:nil block:nil];
    KWLetNode *letNode2 = [KWLetNode letNodeWithSymbolName:nil objectRef:nil block:nil];
    KWContextNode *context = [KWContextNode contextNodeWithCallSite:nil parentContext:nil description:nil];
    [context addLetNode:letNode1];
    [context addLetNode:letNode2];
    NSArray *expectedLetNodes = [NSArray arrayWithObjects:letNode1, letNode2, nil];
    STAssertEqualObjects(context.letNodes, expectedLetNodes, @"expected an array of let nodes in the order they were added");
}

- (void)testNewLetNodesHaveNoRelationships {
    KWLetNode *letNode1 = [KWLetNode letNodeWithSymbolName:@"symbol" objectRef:nil block:nil];
    KWLetNode *letNode2 = [KWLetNode letNodeWithSymbolName:@"symbol" objectRef:nil block:nil];
    KWContextNode *context = [KWContextNode contextNodeWithCallSite:nil parentContext:nil description:nil];
    [context addLetNode:letNode1];
    [context addLetNode:letNode2];
    STAssertNil(letNode1.child, @"expected first let node to have no child");
    STAssertNil(letNode1.next, @"expected first let node to have no next node");
    STAssertNil(letNode1.parent, @"expected first let node to have no parent");
    STAssertNil(letNode1.previous, @"expected first let node to have no previous node");
    STAssertNil(letNode2.child, @"expected second let node to have no child");
    STAssertNil(letNode2.next, @"expected second let node to have no next node");
    STAssertNil(letNode2.parent, @"expected second let node to have no parent");
    STAssertNil(letNode2.previous, @"expected second let node to have no previous node");
}

- (void)testItBuildsATreeOfItsLetNodesWithoutAParentContext {
    KWLetNode *letNode1 = [KWLetNode letNodeWithSymbolName:@"symbol1" objectRef:nil block:nil];
    KWLetNode *letNode2 = [KWLetNode letNodeWithSymbolName:@"symbol2" objectRef:nil block:nil];
    KWContextNode *context = [KWContextNode contextNodeWithCallSite:nil parentContext:nil description:nil];
    [context addLetNode:letNode1];
    [context addLetNode:letNode2];
    KWLetNode *tree = [context letNodeTree];
    STAssertEqualObjects(tree, letNode1, @"expected the root of the tree to be the first let node");
    STAssertEqualObjects(tree.next, letNode2, @"expected the root's next node to be the second let node");
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
    STAssertEqualObjects(tree, letNode1, @"expected the root of the tree to be the first let node");
    STAssertEqualObjects(tree.next, letNode2, @"expected the root's next node to be the second let node");
    STAssertEqualObjects(tree.child, letNode3, @"expected the root's child node to be the third let node");
}

@end

#endif // #if KW_TESTS_ENABLED
