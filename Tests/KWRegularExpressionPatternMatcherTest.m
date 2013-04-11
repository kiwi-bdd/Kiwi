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

@interface KWRegularExpressionPatternMatcherTest : SenTestCase

@end

@implementation KWRegularExpressionPatternMatcherTest

- (void)testItShouldHaveTheRightMatcherStrings {
    NSArray *matcherStrings = [KWRegularExpressionPatternMatcher matcherStrings];
    NSArray *expectedStrings = @[@"matchPattern:"];
    STAssertEqualObjects([matcherStrings sortedArrayUsingSelector:@selector(compare:)],
                         [expectedStrings sortedArrayUsingSelector:@selector(compare:)],
                         @"expected specific matcher strings");
}

- (void)testItShouldMatchLiteralStrings {
    id subject = @"Hello";
    id matcher = [KWRegularExpressionPatternMatcher matcherWithSubject:subject];
    [matcher matchPattern:@"Hello"];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchLiteralStrings {
    id subject = @"Hello";
    id matcher = [KWRegularExpressionPatternMatcher matcherWithSubject:subject];
    [matcher matchPattern:@"Goodbye"];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldMatchGroups {
    id subject = @"ababab";
    id matcher = [KWRegularExpressionPatternMatcher matcherWithSubject:subject];
    [matcher matchPattern:@"(ab)+"];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchGroups {
    id subject = @"ababab";
    id matcher = [KWRegularExpressionPatternMatcher matcherWithSubject:subject];
    [matcher matchPattern:@"(abc)+"];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldHaveHumanReadableDescription {
    id matcher = [KWRegularExpressionPatternMatcher matcherWithSubject:@"foobar"];
    [matcher matchPattern:@"(foo)(bar)"];
    STAssertEqualObjects([matcher description], @"match pattern \"(foo)(bar)\"", @"expected description to match");
}

@end

#endif // #if KW_TESTS_ENABLED
