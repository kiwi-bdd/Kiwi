//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWBeKindOfClassMatcherTest : SenTestCase

@end

@implementation KWBeKindOfClassMatcherTest

- (void)testItShouldHaveTheRightMatcherStrings {
    NSArray *matcherStrings = [KWBeKindOfClassMatcher matcherStrings];
    NSArray *expectedStrings = [NSArray arrayWithObject:@"beKindOfClass:"];
    STAssertEqualObjects([matcherStrings sortedArrayUsingSelector:@selector(compare:)],
                         [expectedStrings sortedArrayUsingSelector:@selector(compare:)],
                         @"expected specific matcher strings");
}

- (void)testItShouldMatchKindOfClass {
    id subject = [Cruiser cruiser];
    id matcher = [KWBeKindOfClassMatcher matcherWithSubject:subject];
    [matcher beKindOfClass:[SpaceShip class]];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchNonKindOfClass {
    id subject = [Cruiser cruiser];
    id matcher = [KWBeKindOfClassMatcher matcherWithSubject:subject];
    [matcher beKindOfClass:[Fighter class]];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldHaveHumanReadableDescription
{
  id matcher = [KWBeKindOfClassMatcher matcherWithSubject:nil];
  [matcher beKindOfClass:[Fighter class]];
  STAssertEqualObjects(@"be kind of Fighter", [matcher description], @"description should match");
}

@end

#endif // #if KW_TESTS_ENABLED
