//
//  KWInvocationCapturerTest.m
//  Kiwi
//
//  Created by Cristian Kocza on 02/04/14.
//  Copyright (c) 2014 Allen Ding. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "KWInvocationCapturer.h"

@interface KWInvocationCapturerTest : SenTestCase

@end

@implementation KWInvocationCapturerTest

- (void)testSTAssertEqualObjectsConvenienceMethod{
    KWInvocationCapturer *invocationCapturer = [KWInvocationCapturer invocationCapturerWithDelegate:self];
    STAssertEquals(invocationCapturer.delegate, self, @"Unexpected invocation capturer delegate");
    STAssertNil(invocationCapturer.userInfo, @"Expected userInfo to be nil");
}
@end
