//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWInequalityMatcherTest : XCTestCase

@end

@implementation KWInequalityMatcherTest

- (void)testItShouldHaveTheRightMatcherStrings {
    NSArray *matcherStrings = [KWInequalityMatcher matcherStrings];
    NSArray *expectedStrings = @[@"beLessThan:",
                                                         @"beLessThanOrEqualTo:",
                                                         @"beGreaterThan:",
                                                         @"beGreaterThanOrEqualTo:"];
    XCTAssertEqualObjects([matcherStrings sortedArrayUsingSelector:@selector(compare:)],
                          [expectedStrings sortedArrayUsingSelector:@selector(compare:)],
                          @"expected specific matcher strings");
}

- (void)testItShouldMatchGreaterValuesForGreaterThan {
    id subject = [KWValue valueWithInt:42];
    KWInequalityMatcher *matcher = [KWInequalityMatcher matcherWithSubject:subject];
    [matcher beGreaterThan:[KWValue valueWithInt:40]];
    XCTAssertTrue([matcher evaluate], @"expected positive match");

    matcher = [KWInequalityMatcher matcherWithSubject:subject];
    [matcher beGreaterThanOrEqualTo:[KWValue valueWithInt:40]];
    XCTAssertTrue([matcher evaluate], @"expected positive match");

    matcher = [KWInequalityMatcher matcherWithSubject:subject];
    [matcher beGreaterThanOrEqualTo:[KWValue valueWithInt:42]];
    XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchNonGreaterValuesForGreaterThan {
    id subject = [KWValue valueWithInt:42];
    KWInequalityMatcher *matcher = [KWInequalityMatcher matcherWithSubject:subject];
    [matcher beGreaterThan:[KWValue valueWithInt:43]];
    XCTAssertFalse([matcher evaluate], @"expected negative match");

    matcher = [KWInequalityMatcher matcherWithSubject:subject];
    [matcher beGreaterThanOrEqualTo:[KWValue valueWithInt:43]];
    XCTAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldMatchLesserValuesForLessThan {
    id subject = [KWValue valueWithInt:42];
    KWInequalityMatcher *matcher = [KWInequalityMatcher matcherWithSubject:subject];
    [matcher beLessThan:[KWValue valueWithInt:43]];
    XCTAssertTrue([matcher evaluate], @"expected positive match");

    matcher = [KWInequalityMatcher matcherWithSubject:subject];
    [matcher beLessThanOrEqualTo:[KWValue valueWithInt:43]];
    XCTAssertTrue([matcher evaluate], @"expected positive match");

    matcher = [KWInequalityMatcher matcherWithSubject:subject];
    [matcher beLessThanOrEqualTo:[KWValue valueWithInt:42]];
    XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchNonLesserValuesForLessThan {
    id subject = [KWValue valueWithInt:42];
    KWInequalityMatcher *matcher = [KWInequalityMatcher matcherWithSubject:subject];
    [matcher beLessThan:[KWValue valueWithInt:41]];
    XCTAssertFalse([matcher evaluate], @"expected negative match");

    matcher = [KWInequalityMatcher matcherWithSubject:subject];
    [matcher beLessThanOrEqualTo:[KWValue valueWithInt:41]];
    XCTAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldHaveHumanReadableDescription
{
  KWInequalityMatcher *matcher = [KWInequalityMatcher matcherWithSubject:theValue(123)];

  [matcher beLessThan:[KWValue valueWithInt:10]];
  XCTAssertEqualObjects(@"be < 10", [matcher description], @"description should match");

  [matcher beLessThanOrEqualTo:[KWValue valueWithInt:10]];
  XCTAssertEqualObjects(@"be <= 10", [matcher description], @"description should match");

  [matcher beGreaterThan:[KWValue valueWithInt:10]];
  XCTAssertEqualObjects(@"be > 10", [matcher description], @"description should match");

  [matcher beGreaterThanOrEqualTo:[KWValue valueWithInt:10]];
  XCTAssertEqualObjects(@"be >= 10", [matcher description], @"description should match");
}

@end

#endif // #if KW_TESTS_ENABLED
