//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWEmptyCollectionMatcherTest : XCTestCase

@end

@implementation KWEmptyCollectionMatcherTest

- (void)testItShouldHaveTheRightMatcherStrings {
    NSArray *matcherStrings = [KWBeEmptyMatcher matcherStrings];
    NSArray *expectedStrings = @[@"beEmpty"];
    XCTAssertEqualObjects([matcherStrings sortedArrayUsingSelector:@selector(compare:)],
                          [expectedStrings sortedArrayUsingSelector:@selector(compare:)],
                          @"expected specific matcher strings");
}

- (void)testItShouldMatchEmptyCollections {
    id subject = @{};
    KWBeEmptyMatcher *matcher = [KWBeEmptyMatcher matcherWithSubject:subject];
    [matcher beEmpty];
    XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchNonEmptyCollections {
    id subject = @{@"foo": @"bar"};
    KWBeEmptyMatcher *matcher = [KWBeEmptyMatcher matcherWithSubject:subject];
    [matcher beEmpty];
    XCTAssertFalse([matcher evaluate], @"expected negative match");
}


- (void)testItShouldHaveHumanReadableDescription
{
  KWBeEmptyMatcher *matcher = [KWBeEmptyMatcher matcherWithSubject:nil];
  XCTAssertEqualObjects(@"be empty", [matcher description], @"description should match");
}

@end

#endif // #if KW_TESTS_ENABLED
