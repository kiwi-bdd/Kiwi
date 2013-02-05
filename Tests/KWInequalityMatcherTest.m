//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWInequalityMatcherTest : SenTestCase

@end

@implementation KWInequalityMatcherTest

- (void)testItShouldHaveTheRightMatcherStrings {
    NSArray *matcherStrings = [KWInequalityMatcher matcherStrings];
    NSArray *expectedStrings = @[@"beLessThan:",
                                                         @"beLessThanOrEqualTo:",
                                                         @"beGreaterThan:",
                                                         @"beGreaterThanOrEqualTo:"];
    STAssertEqualObjects([matcherStrings sortedArrayUsingSelector:@selector(compare:)],
                         [expectedStrings sortedArrayUsingSelector:@selector(compare:)],
                         @"expected specific matcher strings");
}

- (void)testItShouldMatchGreaterValuesForGreaterThan {
    id subject = [KWValue valueWithInt:42];
    id matcher = [KWInequalityMatcher matcherWithSubject:subject];
    [matcher beGreaterThan:[KWValue valueWithInt:40]];
    STAssertTrue([matcher evaluate], @"expected positive match");

    matcher = [KWInequalityMatcher matcherWithSubject:subject];
    [matcher beGreaterThanOrEqualTo:[KWValue valueWithInt:40]];
    STAssertTrue([matcher evaluate], @"expected positive match");

    matcher = [KWInequalityMatcher matcherWithSubject:subject];
    [matcher beGreaterThanOrEqualTo:[KWValue valueWithInt:42]];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchNonGreaterValuesForGreaterThan {
    id subject = [KWValue valueWithInt:42];
    id matcher = [KWInequalityMatcher matcherWithSubject:subject];
    [matcher beGreaterThan:[KWValue valueWithInt:43]];
    STAssertFalse([matcher evaluate], @"expected negative match");

    matcher = [KWInequalityMatcher matcherWithSubject:subject];
    [matcher beGreaterThanOrEqualTo:[KWValue valueWithInt:43]];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldMatchLesserValuesForLessThan {
    id subject = [KWValue valueWithInt:42];
    id matcher = [KWInequalityMatcher matcherWithSubject:subject];
    [matcher beLessThan:[KWValue valueWithInt:43]];
    STAssertTrue([matcher evaluate], @"expected positive match");

    matcher = [KWInequalityMatcher matcherWithSubject:subject];
    [matcher beLessThanOrEqualTo:[KWValue valueWithInt:43]];
    STAssertTrue([matcher evaluate], @"expected positive match");

    matcher = [KWInequalityMatcher matcherWithSubject:subject];
    [matcher beLessThanOrEqualTo:[KWValue valueWithInt:42]];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchNonLesserValuesForLessThan {
    id subject = [KWValue valueWithInt:42];
    id matcher = [KWInequalityMatcher matcherWithSubject:subject];
    [matcher beLessThan:[KWValue valueWithInt:41]];
    STAssertFalse([matcher evaluate], @"expected negative match");

    matcher = [KWInequalityMatcher matcherWithSubject:subject];
    [matcher beLessThanOrEqualTo:[KWValue valueWithInt:41]];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldHaveHumanReadableDescription
{
  id matcher = [KWInequalityMatcher matcherWithSubject:theValue(123)];

  [matcher beLessThan:[KWValue valueWithInt:10]];
  STAssertEqualObjects(@"be < 10", [matcher description], @"description should match");

  [matcher beLessThanOrEqualTo:[KWValue valueWithInt:10]];
  STAssertEqualObjects(@"be <= 10", [matcher description], @"description should match");

  [matcher beGreaterThan:[KWValue valueWithInt:10]];
  STAssertEqualObjects(@"be > 10", [matcher description], @"description should match");

  [matcher beGreaterThanOrEqualTo:[KWValue valueWithInt:10]];
  STAssertEqualObjects(@"be >= 10", [matcher description], @"description should match");
}

@end

#endif // #if KW_TESTS_ENABLED
