//
//  KWFunctionalTests.m
//  Kiwi
//
//  Created by Marin Usalj on 1/24/13.
//  Copyright (c) 2013 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"

static BOOL tests_were_run = NO;

SPEC_BEGIN(Functional)

NSMutableArray *calls = @[@"OuterTestCase",
@"BeforeAll", @"AfterAll", @"BeforeEach", @"AfterEach", @"TestCase",
@"InnerBeforeAll", @"InnerAfterAll", @"InnerBeforeEach", @"InnerAfterEach", @"InnerTestCase",
@"DoubleInnerBeforeAll", @"DoubleInnerAfterAll", @"DoubleInnerBeforeEach", @"DoubleInnerAfterEach", @"DoubleInnerTestCase"
].mutableCopy;

describe(@"OuterDescribe", ^{
    it(@"OuterTestCase", ^{ [calls removeObject:@"OuterTestCase"]; });
    context(@"OuterContext", ^{
        beforeAll(^{ [calls removeObject:@"BeforeAll"]; });
        afterAll(^{ [calls removeObject:@"AfterAll"]; });
        beforeEach(^{ [calls removeObject:@"BeforeEach"]; });
        afterEach(^{ [calls removeObject:@"AfterEach"]; });
        it(@"TestCase", ^{ [calls removeObject:@"TestCase"]; });
        context(@"Context", ^{
            beforeAll(^{ [calls removeObject:@"InnerBeforeAll"]; });
            afterAll(^{ [calls removeObject:@"InnerAfterAll"]; });
            beforeEach(^{ [calls removeObject:@"InnerBeforeEach"]; });
            afterEach(^{ [calls removeObject:@"InnerAfterEach"]; });
            it(@"InnerTestCase", ^{ [calls removeObject:@"InnerTestCase"]; });
            context(@"InnerContext", ^{
                beforeAll(^{ [calls removeObject:@"DoubleInnerBeforeAll"]; });
                afterAll(^{ [calls removeObject:@"DoubleInnerAfterAll"]; });
                beforeEach(^{ [calls removeObject:@"DoubleInnerBeforeEach"]; });
                afterEach(^{ [calls removeObject:@"DoubleInnerAfterEach"]; });
                it(@"DoubleInnerTestCase", ^{ [calls removeObject:@"DoubleInnerTestCase"]; });
            });
        });
    });
});

describe(@"Check", ^{
    it(@"All the blocks were called", ^{
        [[calls should] haveCountOf:0];
        tests_were_run = YES;
    });    
});

SPEC_END


#if KW_TESTS_ENABLED
@interface KWFunctionalTests : SenTestCase
@end
@implementation KWFunctionalTests

- (void)testSuiteWasExecuted {
    STAssertEquals(YES, tests_were_run, @"Test suite hasn't run!");
}

@end
#endif // #if KW_TESTS_ENABLED