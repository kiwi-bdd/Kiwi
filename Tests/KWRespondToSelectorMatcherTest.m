//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWRespondToSelectorMatcherTest : XCTestCase

@end

@implementation KWRespondToSelectorMatcherTest

- (void)testItShouldHaveTheRightMatcherStrings {
    NSArray *matcherStrings = [KWRespondToSelectorMatcher matcherStrings];
    NSArray *expectedStrings = @[@"respondToSelector:"];
    XCTAssertEqualObjects([matcherStrings sortedArrayUsingSelector:@selector(compare:)],
                          [expectedStrings sortedArrayUsingSelector:@selector(compare:)],
                          @"expected specific matcher strings");
}

- (void)testItShouldMatchObjectsThatRespondToSelector {
    id subject = [Cruiser cruiser];
    KWRespondToSelectorMatcher *matcher = [KWRespondToSelectorMatcher matcherWithSubject:subject];
    [matcher respondToSelector:@selector(raiseShields)];
    XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchObjectsThatRespondToSelector {
    id subject = [Cruiser cruiser];
    KWRespondToSelectorMatcher *matcher = [KWRespondToSelectorMatcher matcherWithSubject:subject];
    [matcher respondToSelector:@selector(setObject:forKey:)];
    XCTAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldHaveHumanReadableDescription
{
  KWRespondToSelectorMatcher *matcher = [KWRespondToSelectorMatcher matcherWithSubject:theValue(123)];
  [matcher respondToSelector:@selector(setObject:forKey:)];
  XCTAssertEqualObjects(@"respond to -setObject:forKey:", [matcher description], @"description should match");
}

@end

#endif // #if KW_TESTS_ENABLED
