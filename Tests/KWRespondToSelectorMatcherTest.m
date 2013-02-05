//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWRespondToSelectorMatcherTest : SenTestCase

@end

@implementation KWRespondToSelectorMatcherTest

- (void)testItShouldHaveTheRightMatcherStrings {
    NSArray *matcherStrings = [KWRespondToSelectorMatcher matcherStrings];
    NSArray *expectedStrings = @[@"respondToSelector:"];
    STAssertEqualObjects([matcherStrings sortedArrayUsingSelector:@selector(compare:)],
                         [expectedStrings sortedArrayUsingSelector:@selector(compare:)],
                         @"expected specific matcher strings");
}

- (void)testItShouldMatchObjectsThatRespondToSelector {
    id subject = [Cruiser cruiser];
    id matcher = [KWRespondToSelectorMatcher matcherWithSubject:subject];
    [matcher respondToSelector:@selector(raiseShields)];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchObjectsThatRespondToSelector {
    id subject = [Cruiser cruiser];
    id matcher = [KWRespondToSelectorMatcher matcherWithSubject:subject];
    [matcher respondToSelector:@selector(setObject:forKey:)];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldHaveHumanReadableDescription
{
  id matcher = [KWRespondToSelectorMatcher matcherWithSubject:theValue(123)];
  [matcher respondToSelector:@selector(setObject:forKey:)];
  STAssertEqualObjects(@"respond to -setObject:forKey:", [matcher description], @"description should match");
}

@end

#endif // #if KW_TESTS_ENABLED
