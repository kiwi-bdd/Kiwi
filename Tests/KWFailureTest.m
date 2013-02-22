//
//  KWFailureTest.m
//  Kiwi
//
//  Created by Andrew J Wagner on 2/20/13.
//  Copyright (c) 2013 Allen Ding. All rights reserved.
//

#import "KiwiTestConfiguration.h"
#import "TestClasses.h"
#import "KWFailure.h"

@interface KWFailureTest : SenTestCase

@end

@implementation KWFailureTest

- (void)testExceptionValue {
    KWFailure *failure = [KWFailure failureWithCallSite:nil message:@"a message"];
    STAssertNil([failure exceptionValue].userInfo, @"userInfo should be nil since there was no callSite");
    STAssertEquals([failure exceptionValue].reason, @"a message", @"the reason of the exception should be the same as the one used to create the failure");
}

@end
