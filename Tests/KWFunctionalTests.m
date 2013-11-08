//
//  KWFunctionalTests.m
//  Kiwi
//
//  Created by Marin Usalj on 1/24/13.
//  Copyright (c) 2013 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"

@interface KWExampleSuiteBuilder ()

@property (nonatomic, retain, readwrite) NSString *focusedContextNodeDescription;
@property (nonatomic, retain, readwrite) NSString *focusedItNodeDescription;

@end

static BOOL tests_were_run = NO;

SPEC_BEGIN(Functional)

NSMutableArray *calls = @[@"OuterTestCase",
@"BeforeAll", @"AfterAll", @"BeforeEach", @"AfterEach", @"TestCase",
@"InnerBeforeAll", @"InnerAfterAll", @"InnerBeforeEach", @"InnerAfterEach", @"InnerTestCase",
@"DoubleInnerBeforeAll", @"DoubleInnerAfterAll", @"DoubleInnerBeforeEach", @"DoubleInnerAfterEach", @"DoubleInnerTestCase"
].mutableCopy;

//There should not be a focused call site at this point
assert(![[KWExampleSuiteBuilder sharedExampleSuiteBuilder] focusedCallSite]);

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

SPEC_BEGIN(FunctionalFocusedDescribe)

#pragma mark - Focused describe blocks

NSMutableArray *focusedContextCalls = @[@"InnerBeforeAll", @"InnerAfterAll", @"InnerBeforeEach", @"InnerAfterEach", @"InnerTestCase", @"DoubleInnerBeforeAll", @"DoubleInnerAfterAll", @"DoubleInnerBeforeEach", @"DoubleInnerAfterEach", @"DoubleInnerTestCase"
].mutableCopy;

NSMutableArray *unFocusedContextCalls = @[ @"OuterTestCase", @"BeforeAll", @"AfterAll", @"BeforeEach", @"AfterEach"
].mutableCopy;

[[KWExampleSuiteBuilder sharedExampleSuiteBuilder] setFocusedCallSite:[KWCallSite callSiteWithFilename:@"KWFunctionalTests.m" lineNumber:84]];

describe(@"UnFocusedContext", ^{
    it(@"OuterTestCase", ^{ [unFocusedContextCalls removeObject:@"OuterTestCase"]; });
    beforeAll(^{ [unFocusedContextCalls removeObject:@"BeforeAll"]; });
    afterAll(^{ [unFocusedContextCalls removeObject:@"AfterAll"]; });
    beforeEach(^{ [unFocusedContextCalls removeObject:@"BeforeEach"]; });
    afterEach(^{ [unFocusedContextCalls removeObject:@"AfterEach"]; });
    describe(@"FocusedContext", ^{
        beforeAll(^{ [focusedContextCalls removeObject:@"InnerBeforeAll"]; });
        afterAll(^{ [focusedContextCalls removeObject:@"InnerAfterAll"]; });
        beforeEach(^{ [focusedContextCalls removeObject:@"InnerBeforeEach"]; });
        afterEach(^{ [focusedContextCalls removeObject:@"InnerAfterEach"]; });
        it(@"InnerTestCase", ^{ [focusedContextCalls removeObject:@"InnerTestCase"]; });
        context(@"InnerContext", ^{
            beforeAll(^{ [focusedContextCalls removeObject:@"DoubleInnerBeforeAll"]; });
            afterAll(^{ [focusedContextCalls removeObject:@"DoubleInnerAfterAll"]; });
            beforeEach(^{ [focusedContextCalls removeObject:@"DoubleInnerBeforeEach"]; });
            afterEach(^{ [focusedContextCalls removeObject:@"DoubleInnerAfterEach"]; });
            it(@"DoubleInnerTestCase", ^{ [focusedContextCalls removeObject:@"DoubleInnerTestCase"]; });
        });
    });
});

[[KWExampleSuiteBuilder sharedExampleSuiteBuilder] setFocusedCallSite:nil];

describe(@"FocusedContextCheck", ^{
    it(@"All the blocks were called", ^{
        [[focusedContextCalls should] haveCountOf:0];
        [[unFocusedContextCalls should] haveCountOf:1];
    });
});

SPEC_END

SPEC_BEGIN(FunctionalFocusedIt)

#pragma mark - Focused it blocks

NSMutableArray *focusedItCalls = @[@"FocusedTestCase"].mutableCopy;

NSMutableArray *unFocusedItCalls = @[@"UnFocusedTestCase"].mutableCopy;

[[KWExampleSuiteBuilder sharedExampleSuiteBuilder] setFocusedCallSite:[KWCallSite callSiteWithFilename:@"KWFunctionalTests.m" lineNumber:122]];

describe(@"FocusedIt", ^{
    it(@"FocusedTestCase", ^{ [focusedItCalls removeObject:@"FocusedTestCase"]; });
    it(@"UnFocusedTestCase", ^{ [unFocusedItCalls removeObject:@"UnFocusedTestCase"]; });
});

[[KWExampleSuiteBuilder sharedExampleSuiteBuilder] setFocusedCallSite:nil];

describe(@"FocusedItCheck", ^{
    it(@"All the blocks were called", ^{
        [[focusedItCalls should] haveCountOf:0];
        [[unFocusedItCalls should] haveCountOf:1];
    });
});

SPEC_END

SPEC_BEGIN(FunctionalLet)

describe(@"Greeting", ^{
    let(subject, ^{ return @""; });
    let(greeting, ^{ return [NSString stringWithFormat:@"Hello, %@!", subject]; });

    describe(@"default subject", ^{
        specify(^{ [[subject should] beEmpty]; });
    });

    context(@"with the subject \"world\"", ^{
        let(subject, ^{ return @"world"; });

        specify(^{ [[greeting should] equal:@"Hello, world!"]; });
    });

    context(@"with the subject \"Kiwi\"", ^{
        let(subject, ^{ return @"Kiwi"; });

        specify(^{ [[greeting should] equal:@"Hello, Kiwi!"]; });
    });
});

describe(@"Let context tree", ^{
    let(number, ^{ return @0; });
    let(string, ^{ return [number stringValue]; });

    describe(@"number 1", ^{
        let(number, ^{ return @1; });

        context(@"number 2", ^{
            let(number, ^{ return @2; });

            context(@"number 3", ^{
                let(number, ^{ return @3; });

                context(@"number 4", ^{
                    let(number, ^{ return @4; });

                    specify(^{ [[number should] equal:@4]; });
                    specify(^{ [[string should] equal:@"4"]; });
                });

                specify(^{ [[number should] equal:@3]; });
                specify(^{ [[string should] equal:@"3"]; });
            });

            specify(^{ [[number should] equal:@2];});
            specify(^{ [[string should] equal:@"2"]; });
        });

        context(@"number 5", ^{
            let(number, ^{ return @5; });

            context(@"number 6", ^{
                let(number, ^{ return @6; });

                specify(^{ [[number should] equal:@6]; });
                specify(^{ [[string should] equal:@"6"]; });
            });

            specify(^{ [[number should] equal:@5]; });
            specify(^{ [[string should] equal:@"5"]; });
        });

        specify(^{ [[number should] equal:@1]; });
        specify(^{ [[string should] equal:@"1"]; });
    });
});

SPEC_END

SPEC_BEGIN(NilMatchers)

describe(@"nil matchers", ^{
    __block NSObject *object;

    context(@"when object is nil", ^{
        beforeEach(^{
            object = nil;
        });

        it(@"passes a test for [[x should] beNil]", ^{
            [[object should] beNil];
        });
        it(@"passes a test for [[x shouldNot] beNonNil]", ^{
            [[object shouldNot] beNonNil];
        });
        it(@"passes a test for [x shouldBeNil]", ^{
            [object shouldBeNil];
        });
    });

    context(@"when object is non-nil", ^{
        beforeEach(^{
            object = [NSObject new];
        });
        it(@"passes a test for [[x should] beNonNil]", ^{
            [[object should] beNonNil];
        });
        it(@"passes a test for [[x shouldNot] beNil]", ^{
            [[object shouldNot] beNil];
        });
        it(@"passes a test for [x shouldNotBeNil]", ^{
            [object shouldNotBeNil];
        });
    });
});

SPEC_END

SPEC_BEGIN(NSDateStub)

describe(@"NSDate stubs", ^{
	__block id dateMock = nil;
	context(@"shouldEventually should work when [NSDate date] is mocked and stubbed", ^{
		beforeEach(^{
			dateMock = [NSDate mock];
			[dateMock stub: @selector(timeIntervalSince1970) andReturn: [KWValue valueWithDouble: 1.0f]];
			[NSDate stub: @selector(date) andReturn: dateMock];
		});
		
		it(@"should not hang", ^{
			[[theValue([[NSDate date] timeIntervalSince1970]) shouldNotEventually] equal: 5.0f withDelta: 0.5f];
		});
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
