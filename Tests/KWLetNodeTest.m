//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "KiwiTestConfiguration.h"
#import "KWLetNode.h"

#if KW_TESTS_ENABLED

@interface KWLetNodeTest : XCTestCase

@end

@implementation KWLetNodeTest

#pragma mark - Building let node trees

- (void)testRelationshipReferencesAreNilAfterInitialisation {
    KWLetNode *letNode1 = [KWLetNode letNodeWithSymbolName:@"no relationship" objectRef:nil block:nil];
    XCTAssertNil(letNode1.parent, @"expected a new let node to have no parent");
    XCTAssertNil(letNode1.child, @"expected a new let node to have no child");
    XCTAssertNil(letNode1.previous, @"expected a new let node to have no previous symbol");
    XCTAssertNil(letNode1.next, @"expected a new let node to have no next symbol");
}

- (void)testItAddsANodeWithTheSameSymbolAsAChild {
    KWLetNode *letNode1 = [KWLetNode letNodeWithSymbolName:@"number" objectRef:nil block:nil];
    KWLetNode *letNode2 = [KWLetNode letNodeWithSymbolName:@"number" objectRef:nil block:nil];
    [letNode1 addLetNode:letNode2];
    XCTAssertEqualObjects(letNode1.child, letNode2, @"expected the second 'number' node to be the child of the first");
    XCTAssertEqualObjects(letNode2.parent, letNode1, @"expected the first 'number' node to be the parent of the second");
    XCTAssertNil(letNode1.next, @"expected no 'next' node to be set");
    XCTAssertNil(letNode2.previous, @"expected no 'previous' node to be set");
}

- (void)testItAddsANodeWithADifferentSymbolAsNext {
    KWLetNode *letNode1 = [KWLetNode letNodeWithSymbolName:@"number" objectRef:nil block:nil];
    KWLetNode *letNode2 = [KWLetNode letNodeWithSymbolName:@"not a number" objectRef:nil block:nil];
    [letNode1 addLetNode:letNode2];
    XCTAssertEqualObjects(letNode1.next, letNode2, @"expected the second node to be the next of the first");
    XCTAssertEqualObjects(letNode2.previous, letNode1, @"expected the first node to be the previous of the second");
    XCTAssertNil(letNode1.child, @"expected no 'child' node to be set");
    XCTAssertNil(letNode2.parent, @"expected no 'parent' node to be set");
}

- (void)testItBuildsATreeofNodes {
    KWLetNode *letNode1 = [KWLetNode letNodeWithSymbolName:@"foo" objectRef:nil block:nil];
    KWLetNode *letNode2 = [KWLetNode letNodeWithSymbolName:@"foo" objectRef:nil block:nil];
    KWLetNode *letNode3 = [KWLetNode letNodeWithSymbolName:@"bar" objectRef:nil block:nil];
    KWLetNode *letNode4 = [KWLetNode letNodeWithSymbolName:@"bar" objectRef:nil block:nil];
    KWLetNode *letNode5 = [KWLetNode letNodeWithSymbolName:@"baz" objectRef:nil block:nil];
    [letNode1 addLetNode:letNode2];
    [letNode1 addLetNode:letNode3];
    [letNode1 addLetNode:letNode4];
    [letNode1 addLetNode:letNode5];
    XCTAssertEqualObjects(letNode1.child, letNode2, @"expected the second 'foo' node to be a child of the first");
    XCTAssertEqualObjects(letNode1.next, letNode3, @"expected the first 'bar' node to be next after 'foo'");
    XCTAssertEqualObjects(letNode3.child, letNode4, @"expected the second 'bar' node to be a child of the first");
    XCTAssertEqualObjects(letNode3.next, letNode5, @"expected the 'baz' node to be next after 'bar'");
    XCTAssertEqualObjects(letNode3.previous, letNode1, @"expected the first 'foo' node to be the previous of the first 'bar' node");
    XCTAssertEqualObjects(letNode4.parent, letNode3, @"expected the first 'bar' node to be the parent of the second");
    XCTAssertEqualObjects(letNode5.previous, letNode3, @"expected the first 'bar' node to be the previous of the 'baz' node");
}

- (void)testItUnlinksASubtreeOfNodes {
    KWLetNode *letNode1 = [KWLetNode letNodeWithSymbolName:@"foo" objectRef:nil block:nil];
    KWLetNode *letNode2 = [KWLetNode letNodeWithSymbolName:@"foo" objectRef:nil block:nil];
    KWLetNode *letNode3 = [KWLetNode letNodeWithSymbolName:@"bar" objectRef:nil block:nil];
    KWLetNode *letNode4 = [KWLetNode letNodeWithSymbolName:@"bar" objectRef:nil block:nil];
    KWLetNode *letNode5 = [KWLetNode letNodeWithSymbolName:@"baz" objectRef:nil block:nil];
    [letNode1 addLetNode:letNode2];
    [letNode1 addLetNode:letNode3];
    [letNode1 addLetNode:letNode4];
    [letNode1 addLetNode:letNode5];
    [letNode3 unlink];
    XCTAssertEqualObjects(letNode1.child, letNode2, @"expected the root node to have a child");
    XCTAssertNil(letNode1.next, @"expected the root node to have no next node");
    XCTAssertNil(letNode3.child, @"expected the first 'bar' node to have no children");
    XCTAssertNil(letNode3.next, @"expected the first 'bar' node to have no next node");
    XCTAssertNil(letNode3.previous, @"expected the first 'bar' node to have no previous node");
    XCTAssertNil(letNode4.parent, @"expected the second 'bar' node to have no parent node");
    XCTAssertNil(letNode5.previous, @"expected the 'baz' node to have no previous node");
}

#pragma mark - Evaluating let node blocks

- (void)testItSetsItsObjectRefWhenEvaluated {
    __block id number = nil;
    KWLetNode *letNode = [KWLetNode letNodeWithSymbolName:@"number" objectRef:&number block:^{ return @5; }];
    [letNode evaluate];
    XCTAssertEqualObjects(number, @5, @"expected the object to be set to the block's return value after evaluation");
}

- (void)testItSetsAllObjectRefsToTheChildsValueWhenEvaluated {
    __block id number1 = nil, number2 = nil;
    KWLetNode *letNode1 = [KWLetNode letNodeWithSymbolName:@"number" objectRef:&number1 block:^{ return @1; }];
    KWLetNode *letNode2 = [KWLetNode letNodeWithSymbolName:@"number" objectRef:&number2 block:^{ return @2; }];
    [letNode1 addLetNode:letNode2];
    [letNode1 evaluate];
    XCTAssertEqualObjects(number2, @2, @"expected the child object to have the value '2' after evaluation");
    XCTAssertEqualObjects(number1, number2, @"expected the parent object to have the same value as the child");
}

- (void)testItEvaluatesTheDeepestChild {
    __block NSNumber *number = nil;
    __block NSString *string = nil;
    KWLetNode *letNode1 = [KWLetNode letNodeWithSymbolName:@"number" objectRef:&number block:^{ return @1; }];
    KWLetNode *letNode2 = [KWLetNode letNodeWithSymbolName:@"string" objectRef:&string block:^{ return [number stringValue]; }];
    KWLetNode *letNode3 = [KWLetNode letNodeWithSymbolName:@"number" objectRef:&number block:^{ return @2; }];
    [letNode1 addLetNode:letNode2];
    [letNode1 addLetNode:letNode3];
    [letNode1 evaluateTree];
    XCTAssertEqualObjects(string, @"2", @"expected the last node to be based on the value of the deepest previous child");
}

#pragma mark - Example node visiting

- (void)testItSendsVisitLetNodeToTheVisitor {
    __block BOOL visitorCalled = NO;
    __block id visitorArgument = nil;

    KWLetNode *letNode = [KWLetNode letNodeWithSymbolName:@"symbol" objectRef:nil block:nil];
    KWMock<KWExampleNodeVisitor> *visitor = [KWMock mockForProtocol:@protocol(KWExampleNodeVisitor)];
    [visitor stub:@selector(visitLetNode:) withBlock:^id(NSArray *params) {
        visitorCalled = YES;
        visitorArgument = params[0];
        return nil;
    }];

    [letNode acceptExampleNodeVisitor:visitor];

    XCTAssertTrue(visitorCalled, @"expected let node to send 'visitLetNode:' to the visitor");
    XCTAssertEqualObjects(visitorArgument, letNode, @"expected let node to pass a reference to itself to the visitor");
}

@end

#endif // #if KW_TESTS_ENABLED
