//
//  KWObjCUtilitiesTest.m
//  Kiwi
//
//  Created by Brian Ivan Gesiak on 9/16/13.
//  Copyright (c) 2013 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"

#if KW_TESTS_ENABLED

@interface KWObjCUtilitiesTest : SenTestCase

@end

@implementation KWObjCUtilitiesTest

#pragma mark KWObjCTypeIsBoolean

- (void)testBOOLIsABoolean {
    STAssertTrue(KWObjCTypeIsBoolean(@encode(BOOL)),
                 @"Expected BOOL to be evaluated as a boolean.");
}

- (void)testStdBoolIsABoolean {
    STAssertTrue(KWObjCTypeIsBoolean(@encode(bool)),
                 @"Expected bool to be evaluated as a boolean.");
}

- (void)testIntIsNotABoolean {
    STAssertFalse(KWObjCTypeIsBoolean(@encode(int)),
                  @"Did not expect int type to be evaluated as a boolean.");
}

#pragma mark KWSelectorParameterCount

- (void)testNumberOfParametersInMethodThatTakesNoParametersIsZero {
    STAssertEquals(KWSelectorParameterCount(@selector(description)), (NSUInteger)0,
                   @"Expected -description to have a parameter count of 0.");
}

- (void)testNumberOfParametersInMethodThatTakesTwoParametersIsTwo {
    STAssertEquals(KWSelectorParameterCount(@selector(performSelector:withObject:)), (NSUInteger)2,
                   @"Expected -performSelector:withObject: to have a parameter count of 2.");
}

@end

#endif
