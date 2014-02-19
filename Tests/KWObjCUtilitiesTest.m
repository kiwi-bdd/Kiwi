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

#pragma mark KWObjCTypeIsBool

- (void)testItRecognizesBoolObjCTypes {
    STAssertTrue(KWObjCTypeIsBool(@encode(BOOL)),
                 @"Expected BOOL type to be evaluated as a BOOL.");
}

- (void)testItRecognizesNonBoolObjCTypes {
    STAssertFalse(KWObjCTypeIsBool(@encode(int)),
                  @"Did not expect int type to be evaluated as a BOOL.");
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
