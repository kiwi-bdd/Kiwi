//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWEqualMatcherTest : SenTestCase

@end

@implementation KWEqualMatcherTest

- (void)testItShouldHaveTheRightMatcherStrings {
    NSArray *matcherStrings = [KWEqualMatcher matcherStrings];
    NSArray *expectedStrings = [NSArray arrayWithObjects:@"equal:", nil];
    STAssertEqualObjects([matcherStrings sortedArrayUsingSelector:@selector(compare:)],
                         [expectedStrings sortedArrayUsingSelector:@selector(compare:)],
                         @"expected specific matcher strings");
}

- (void)testItShouldMatchEqualObjects {
    id subject = @"foo";
    id otherSubject = @"foo";
    id matcher = [KWEqualMatcher matcherWithSubject:subject];
    [matcher equal:otherSubject];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchUnequalObjects {
    id subject = @"foo";
    id otherSubject = @"foos";
    id matcher = [KWEqualMatcher matcherWithSubject:subject];
    [matcher equal:otherSubject];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldMatchKiwiBoxedValuesWithKiwiBoxedValues {
  id matcher = [KWEqualMatcher matcherWithSubject:theValue(123)];
  [matcher equal:theValue(123)];
  STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldMatchNumberBoxedValuesWithKiwiBoxedValues {
  id matcher = [KWEqualMatcher matcherWithSubject:[NSNumber numberWithInteger:123]];
  [matcher equal:theValue(123)];
  STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldMatchKiwiBoxedValuesWithNumberBoxedValues {
  id matcher = [KWEqualMatcher matcherWithSubject:theValue(123)];
  [matcher equal:[NSNumber numberWithInteger:123]];
  STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldHaveHumanReadableDescription
{
  id matcher = [KWEqualMatcher matcherWithSubject:theValue(123)];
  [matcher equal:@"test value"];
  STAssertEqualObjects(@"equal \"test value\"", [matcher description], @"description should match");
}

@end

#endif // #if KW_TESTS_ENABLED
