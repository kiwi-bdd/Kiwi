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

- (void)testFailureWithCallSiteConvenienceMethod{
    KWCallSite *aCallSite= [KWCallSite callSiteWithFilename:@"aFilename" lineNumber:15];
    KWFailure *failure = [KWFailure failureWithCallSite:aCallSite format:@"Test %@, %d", @"string1", 6];
    STAssertEqualObjects(failure.callSite.filename, @"aFilename", @"Unexpected call site filename");
    STAssertEquals(failure.callSite.lineNumber, (NSUInteger)15, @"Unexpected call site line number");
    STAssertEqualObjects(failure.message, @"Test string1, 6", @"Unexpected call site message");
}

@end
