//
// Licensed under the terms in License.txt
//
// Copyright 2013 Eloy Durán. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWChangeMatcherTest : XCTestCase

@end

@implementation KWChangeMatcherTest

#pragma mark - KWMatcher API

- (void)testItShouldHaveTheRightMatcherStrings {
    NSArray *matcherStrings = [KWChangeMatcher matcherStrings];
    NSArray *expectedStrings = @[@"change:", @"change:by:"];
    XCTAssertEqualObjects([matcherStrings sortedArrayUsingSelector:@selector(compare:)],
                          [expectedStrings sortedArrayUsingSelector:@selector(compare:)],
                          @"expected specific matcher strings");
}

#pragma mark - Exact changes

- (void)testItShouldMatchPositiveChanges {
    __block NSInteger value = 21;
    id subject = theBlock(^{ value = 42; });
    KWChangeMatcher *matcher = [KWChangeMatcher matcherWithSubject:subject];
    [matcher change:^{ return value; } by:+21];
    XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldMatchNegativeChanges {
    __block NSInteger value = 42;
    id subject = theBlock(^{ value = 21; });
    KWChangeMatcher *matcher = [KWChangeMatcher matcherWithSubject:subject];
    [matcher change:^{ return value; } by:-21];
    XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchUnexpectedChanges {
    __block NSInteger value = 21;
    id subject = theBlock(^{ value = 42; });
    KWChangeMatcher *matcher = [KWChangeMatcher matcherWithSubject:subject];
    [matcher change:^{ return value; } by:+1];
    XCTAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldNotMatchWhenExactChangeIsExpected {
    __block NSInteger value = 42;
    id subject = theBlock(^{ value = 42; });
    KWChangeMatcher *matcher = [KWChangeMatcher matcherWithSubject:subject];
    [matcher change:^{ return value; } by:-21];
    XCTAssertFalse([matcher evaluate], @"expected negative match");
}

#pragma mark - Any changes

- (void)testItShouldMatchAnyChange {
    __block NSInteger value = 21;
    id subject = theBlock(^{ value = 42; });
    KWChangeMatcher *matcher = [KWChangeMatcher matcherWithSubject:subject];
    [matcher change:^{ return value; }];
    XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchNoChangeWhenAnyChangeIsExpected {
    __block NSInteger value = 42;
    id subject = theBlock(^{ value = 42; });
    KWChangeMatcher *matcher = [KWChangeMatcher matcherWithSubject:subject];
    [matcher change:^{ return value; }];
    XCTAssertFalse([matcher evaluate], @"expected negative match");
}

@end

#endif // #if KW_TESTS_ENABLED
