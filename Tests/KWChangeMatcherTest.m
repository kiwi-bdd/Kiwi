//
// Licensed under the terms in License.txt
//
// Copyright 2013 Eloy Durán. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWChangeMatcherTest : SenTestCase

@end

@implementation KWChangeMatcherTest

#pragma mark - KWMatcher API

- (void)testItShouldHaveTheRightMatcherStrings {
    NSArray *matcherStrings = [KWChangeMatcher matcherStrings];
    NSArray *expectedStrings = @[@"change:", @"change:by:"];
    STAssertEqualObjects([matcherStrings sortedArrayUsingSelector:@selector(compare:)],
                         [expectedStrings sortedArrayUsingSelector:@selector(compare:)],
                         @"expected specific matcher strings");
}

#pragma mark - Exact changes

- (void)testItShouldMatchPositiveChanges {
    __block NSInteger value = 21;
    id subject = theBlock(^{ value = 42; });
    id matcher = [KWChangeMatcher matcherWithSubject:subject];
    [matcher change:^{ return value; } by:+21];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldMatchNegativeChanges {
    __block NSInteger value = 42;
    id subject = theBlock(^{ value = 21; });
    id matcher = [KWChangeMatcher matcherWithSubject:subject];
    [matcher change:^{ return value; } by:-21];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchUnexpectedChanges {
    __block NSInteger value = 21;
    id subject = theBlock(^{ value = 42; });
    id matcher = [KWChangeMatcher matcherWithSubject:subject];
    [matcher change:^{ return value; } by:+1];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldNotMatchWhenExactChangeIsExpected {
    __block NSInteger value = 42;
    id subject = theBlock(^{ value = 42; });
    id matcher = [KWChangeMatcher matcherWithSubject:subject];
    [matcher change:^{ return value; } by:-21];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

#pragma mark - Any changes

- (void)testItShouldMatchAnyChange {
    __block NSInteger value = 21;
    id subject = theBlock(^{ value = 42; });
    id matcher = [KWChangeMatcher matcherWithSubject:subject];
    [matcher change:^{ return value; }];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchNoChangeWhenAnyChangeIsExpected {
    __block NSInteger value = 42;
    id subject = theBlock(^{ value = 42; });
    id matcher = [KWChangeMatcher matcherWithSubject:subject];
    [matcher change:^{ return value; }];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

@end

#endif // #if KW_TESTS_ENABLED
