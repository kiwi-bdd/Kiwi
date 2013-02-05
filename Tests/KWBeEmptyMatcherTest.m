//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWEmptyCollectionMatcherTest : SenTestCase

@end

@implementation KWEmptyCollectionMatcherTest

- (void)testItShouldHaveTheRightMatcherStrings {
    NSArray *matcherStrings = [KWBeEmptyMatcher matcherStrings];
    NSArray *expectedStrings = @[@"beEmpty"];
    STAssertEqualObjects([matcherStrings sortedArrayUsingSelector:@selector(compare:)],
                         [expectedStrings sortedArrayUsingSelector:@selector(compare:)],
                         @"expected specific matcher strings");
}

- (void)testItShouldMatchEmptyCollections {
    id subject = @{};
    id matcher = [KWBeEmptyMatcher matcherWithSubject:subject];
    [matcher beEmpty];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchNonEmptyCollections {
    id subject = @{@"foo": @"bar"};
    id matcher = [KWBeEmptyMatcher matcherWithSubject:subject];
    [matcher beEmpty];
    STAssertFalse([matcher evaluate], @"expected negative match");
}


- (void)testItShouldHaveHumanReadableDescription
{
  id matcher = [KWBeEmptyMatcher matcherWithSubject:nil];
  STAssertEqualObjects(@"be empty", [matcher description], @"description should match");
}

@end

#endif // #if KW_TESTS_ENABLED
