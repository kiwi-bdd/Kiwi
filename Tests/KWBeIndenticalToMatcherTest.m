//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWBeIdenticalToMatcherTest : SenTestCase

@end

@implementation KWBeIdenticalToMatcherTest

- (void)testItShouldHaveTheRightMatcherStrings {
    NSArray *matcherStrings = [KWBeIdenticalToMatcher matcherStrings];
    NSArray *expectedStrings = @[@"beIdenticalTo:"];
    STAssertEqualObjects([matcherStrings sortedArrayUsingSelector:@selector(compare:)],
                         [expectedStrings sortedArrayUsingSelector:@selector(compare:)],
                         @"expected specific matcher strings");
}

- (void)testItShouldMatchIdenticalObjects {
    id subject = [Cruiser cruiser];
    id matcher = [KWBeIdenticalToMatcher matcherWithSubject:subject];
    [matcher beIdenticalTo:subject];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchDifferentObjects {
    id subject = [Cruiser cruiser];
    id otherSubject = [Cruiser cruiser];
    id matcher = [KWBeIdenticalToMatcher matcherWithSubject:subject];
    [matcher beIdenticalTo:otherSubject];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldHaveHumanReadableDescription
{
  id matcher = [KWBeIdenticalToMatcher matcherWithSubject:nil];
  [matcher beIdenticalTo:@"foo"];
  STAssertEqualObjects(@"be identical to foo", [matcher description], @"description should match");
}

@end

#endif // #if KW_TESTS_ENABLED
