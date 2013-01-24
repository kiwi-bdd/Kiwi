//
//  KWFunctionalTests.m
//  Kiwi
//
//  Created by Marin Usalj on 1/24/13.
//  Copyright (c) 2013 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWFunctionalTests : SenTestCase
@end

@implementation KWFunctionalTests

- (void)testInnerContextsAreExecuted {
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
    STAssertEquals(0, calls.count, @"Not all the blocks were called! Leftovers: %@", calls);
}

@end

#endif // #if KW_TESTS_ENABLED
