//
//  KWObjCUtilitiesTest.m
//  Kiwi
//
//  Created by Brian Ivan Gesiak on 9/16/13.
//  Copyright (c) 2013 Allen Ding. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "KiwiTestConfiguration.h"

#if KW_TESTS_ENABLED

@interface KWObjCUtilitiesTest : XCTestCase

@end

@implementation KWObjCUtilitiesTest

#pragma mark KWObjCTypeIsBoolean

- (void)testBOOLIsABoolean {
    XCTAssertTrue(KWObjCTypeIsBoolean(@encode(BOOL)),
                 @"Expected BOOL to be evaluated as a boolean.");
}

- (void)testStdBoolIsABoolean {
    XCTAssertTrue(KWObjCTypeIsBoolean(@encode(bool)),
                 @"Expected bool to be evaluated as a boolean.");
}

- (void)testIntIsNotABoolean {
    XCTAssertFalse(KWObjCTypeIsBoolean(@encode(int)),
                  @"Did not expect int type to be evaluated as a boolean.");
}

#pragma mark KWSelectorParameterCount

- (void)testNumberOfParametersInMethodThatTakesNoParametersIsZero {
    XCTAssertEqual(KWSelectorParameterCount(@selector(description)), (NSUInteger)0,
                   @"Expected -description to have a parameter count of 0.");
}

- (void)testNumberOfParametersInMethodThatTakesTwoParametersIsTwo {
    XCTAssertEqual(KWSelectorParameterCount(@selector(performSelector:withObject:)), (NSUInteger)2,
                   @"Expected -performSelector:withObject: to have a parameter count of 2.");
}

@end

#endif
