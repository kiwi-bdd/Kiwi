//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWEqualMatcherTest : XCTestCase

@end

@implementation KWEqualMatcherTest

- (void)testItShouldHaveTheRightMatcherStrings {
    NSArray *matcherStrings = [KWEqualMatcher matcherStrings];
    NSArray *expectedStrings = @[@"equal:"];
    XCTAssertEqualObjects([matcherStrings sortedArrayUsingSelector:@selector(compare:)],
                          [expectedStrings sortedArrayUsingSelector:@selector(compare:)],
                          @"expected specific matcher strings");
}

- (void)testItShouldMatchEqualObjects {
    id subject = @"foo";
    id otherSubject = @"foo";
    KWEqualMatcher *matcher = [KWEqualMatcher matcherWithSubject:subject];
    [matcher equal:otherSubject];
    XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchUnequalObjects {
    id subject = @"foo";
    id otherSubject = @"foos";
    KWEqualMatcher *matcher = [KWEqualMatcher matcherWithSubject:subject];
    [matcher equal:otherSubject];
    XCTAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldMatchKiwiBoxedValuesWithKiwiBoxedValues {
  KWEqualMatcher *matcher = [KWEqualMatcher matcherWithSubject:theValue(123)];
  [matcher equal:theValue(123)];
  XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldMatchNumberBoxedValuesWithKiwiBoxedValues {
  KWEqualMatcher *matcher = [KWEqualMatcher matcherWithSubject:@123];
  [matcher equal:theValue(123)];
  XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldMatchKiwiBoxedValuesWithNumberBoxedValues {
  KWEqualMatcher *matcher = [KWEqualMatcher matcherWithSubject:theValue(123)];
  [matcher equal:@123];
  XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldMatchEqualPointerValues {
  int subject = 123;
  KWEqualMatcher *matcher = [KWEqualMatcher matcherWithSubject:thePointerValue(&subject)];
  [matcher equal:thePointerValue(&subject)];
  XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchUnequalPointerValues {
  int subject = 123;
  KWEqualMatcher *matcher = [KWEqualMatcher matcherWithSubject:thePointerValue(&subject)];
  [matcher equal:thePointerValue(NULL)];
  XCTAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldHaveHumanReadableDescription {
  KWEqualMatcher *matcher = [KWEqualMatcher matcherWithSubject:theValue(123)];
  [matcher equal:@"test value"];
  XCTAssertEqualObjects(@"equal (NSString) \"test value\"", [matcher description], @"description should match");
}

- (void)testItShouldIncludeClassesInFailureMessage {
  KWEqualMatcher *matcher = [KWEqualMatcher matcherWithSubject:[NSURL URLWithString:@"http://www.example.com/"]];
  [matcher equal:@"http://www.example.com/"];
  XCTAssertEqualObjects(@"expected subject to equal (NSString) \"http://www.example.com/\", got (NSURL) http://www.example.com/",
                        [matcher failureMessageForShould],
                        @"failure message should include subject and otherSubject class names");
}

@end

#endif // #if KW_TESTS_ENABLED
