//
//  KWRegularExpressionPatternMatcherTest.m
//  Kiwi
//
//  Created by Kristopher Johnson on 4/11/13.
//  Copyright (c) 2013 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWRegularExpressionPatternMatcherTest : XCTestCase

@end

@implementation KWRegularExpressionPatternMatcherTest

- (void)testItShouldHaveTheRightMatcherStrings {
    NSArray *matcherStrings = [KWRegularExpressionPatternMatcher matcherStrings];
    NSArray *expectedStrings = @[@"matchPattern:", @"matchPattern:options:"];
    XCTAssertEqualObjects([matcherStrings sortedArrayUsingSelector:@selector(compare:)],
                          [expectedStrings sortedArrayUsingSelector:@selector(compare:)],
                          @"expected specific matcher strings");
}

- (void)testItShouldMatchLiteralStrings {
    id subject = @"Hello";
    KWRegularExpressionPatternMatcher *matcher = [KWRegularExpressionPatternMatcher matcherWithSubject:subject];
    [matcher matchPattern:@"Hello"];
    XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchLiteralStrings {
    id subject = @"Hello";
    KWRegularExpressionPatternMatcher *matcher = [KWRegularExpressionPatternMatcher matcherWithSubject:subject];
    [matcher matchPattern:@"Goodbye"];
    XCTAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldMatchGroups {
    id subject = @"ababab";
    KWRegularExpressionPatternMatcher *matcher = [KWRegularExpressionPatternMatcher matcherWithSubject:subject];
    [matcher matchPattern:@"(ab)+"];
    XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchGroups {
    id subject = @"ababab";
    KWRegularExpressionPatternMatcher *matcher = [KWRegularExpressionPatternMatcher matcherWithSubject:subject];
    [matcher matchPattern:@"(abc)+"];
    XCTAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldMatchCaseInsensitive {
    id subject = @"abABab";
    KWRegularExpressionPatternMatcher *matcher = [KWRegularExpressionPatternMatcher matcherWithSubject:subject];
    [matcher matchPattern:@"(ab)+" options:NSRegularExpressionCaseInsensitive];
    XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchCaseInsensitive {
    id subject = @"abABab";
    KWRegularExpressionPatternMatcher *matcher = [KWRegularExpressionPatternMatcher matcherWithSubject:subject];
    [matcher matchPattern:@"(abc)+" options:NSRegularExpressionCaseInsensitive];
    XCTAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldHaveHumanReadableDescription {
    KWRegularExpressionPatternMatcher *matcher = [KWRegularExpressionPatternMatcher matcherWithSubject:@"foobar"];
    [matcher matchPattern:@"(foo)(bar)"];
    XCTAssertEqualObjects([matcher description], @"match pattern \"(foo)(bar)\"", @"expected description to match");
}

@end

#endif // #if KW_TESTS_ENABLED
