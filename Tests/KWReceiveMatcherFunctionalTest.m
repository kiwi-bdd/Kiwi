//
//  KWReceiveMatcherFunctionalTest.m
//  Kiwi
//
//  Created by Brian Ivan Gesiak on 3/2/14.
//  Copyright 2014 Allen Ding. All rights reserved.
//


#import "Kiwi.h"
#import "Robot.h"

SPEC_BEGIN(KWReceiveMatcherFunctionalTest)

describe(@"Robot", ^{
    __block Robot *robot = nil;
    beforeEach(^{
        robot = [Robot robot];
    });

    describe(@"-speakContentsOfURL:", ^{
        it(@"should receive the correct arguments", ^{
            [[robot should] receive:@selector(speak:)
                      withArguments:@"http://robotsanonymous.io"];
            [robot speakURL:[NSURL URLWithString:@"http://robotsanonymous.io"]];
        });
    });

    describe(@"-phoneHome:", ^{
        it(@"should pass the correct arguments to the server", ^{
            NSDictionary *expectedParameters = @{
                @"user_agent" : @"AppleRobot/537.36 (KHTML, like Gecko)"
            };

            void (^testCallback)(void) = ^{ NSLog(@"Robot phoning home!"); };
            [[robot should] receive:@selector(contactBaseServerAtPath:parameters:operation:callback:responseEncoding:requestMethod:httpClient:)
                      withArguments:@"api/v2/robots/phone_home",
                                    expectedParameters,
                                    nil,
                                    testCallback,
                                    theValue(RobotServerResponseEncodingJSON),
                                    theValue(RobotServerRequestMethodPOST),
                                    nil];

            [robot phoneHome:testCallback];
        });
    });
});

SPEC_END

