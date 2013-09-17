//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "KWLetNode.h"

#if KW_TESTS_ENABLED

@interface KWLetNodeTest : SenTestCase

@end

@implementation KWLetNodeTest

#pragma mark - Building let node trees

- (void)testRelationshipReferencesAreNilAfterInitialisation {
    KWLetNode *letNode1 = [KWLetNode letNodeWithSymbolName:@"no relationship" objectRef:nil block:nil];
    STAssertNil(letNode1.parent, @"expected a new let node to have no parent");
    STAssertNil(letNode1.child, @"expected a new let node to have no child");
    STAssertNil(letNode1.previous, @"expected a new let node to have no previous symbol");
    STAssertNil(letNode1.next, @"expected a new let node to have no next symbol");
}

- (void)testItAddsANodeWithTheSameSymbolAsAChild {
    KWLetNode *letNode1 = [KWLetNode letNodeWithSymbolName:@"number" objectRef:nil block:nil];
    KWLetNode *letNode2 = [KWLetNode letNodeWithSymbolName:@"number" objectRef:nil block:nil];
    [letNode1 addLetNode:letNode2];
    STAssertEqualObjects(letNode1.child, letNode2, @"expected the second 'number' node to be the child of the first");
    STAssertEqualObjects(letNode2.parent, letNode1, @"expected the first 'number' node to be the parent of the second");
    STAssertNil(letNode1.next, @"expected no 'next' node to be set");
    STAssertNil(letNode2.previous, @"expected no 'previous' node to be set");
}

- (void)testItAddsANodeWithADifferentSymbolAsNext {
    KWLetNode *letNode1 = [KWLetNode letNodeWithSymbolName:@"number" objectRef:nil block:nil];
    KWLetNode *letNode2 = [KWLetNode letNodeWithSymbolName:@"not a number" objectRef:nil block:nil];
    [letNode1 addLetNode:letNode2];
    STAssertEqualObjects(letNode1.next, letNode2, @"expected the second node to be the next of the first");
    STAssertEqualObjects(letNode2.previous, letNode1, @"expected the first node to be the previous of the second");
    STAssertNil(letNode1.child, @"expected no 'child' node to be set");
    STAssertNil(letNode2.parent, @"expected no 'parent' node to be set");
}

#pragma mark - Evaluating let node blocks

- (void)testItSetsItsObjectRefWhenEvaluated {
    __block id number = nil;
    KWLetNode *letNode = [KWLetNode letNodeWithSymbolName:@"number" objectRef:&number block:^{ return @5; }];
    [letNode evaluate];
    STAssertEqualObjects(number, @5, @"expected the object to be set to the block's return value after evaluation");
}

- (void)testItSetsAllObjectRefsToTheChildsValueWhenEvaluated {
    __block id number1 = nil, number2 = nil;
    KWLetNode *letNode1 = [KWLetNode letNodeWithSymbolName:@"number" objectRef:&number1 block:^{ return @1; }];
    KWLetNode *letNode2 = [KWLetNode letNodeWithSymbolName:@"number" objectRef:&number2 block:^{ return @2; }];
    [letNode1 addLetNode:letNode2];
    [letNode1 evaluate];
    STAssertEqualObjects(number2, @2, @"expected the child object to have the value '2' after evaluation");
    STAssertEqualObjects(number1, number2, @"expected the parent object to have the same value as the child");
}

@end

#endif // #if KW_TESTS_ENABLED
