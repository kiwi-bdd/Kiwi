//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWBeMemberOfClassMatcherTest : SenTestCase

@end

@implementation KWBeMemberOfClassMatcherTest

- (void)testItShouldHaveTheRightMatcherStrings {
    NSArray *matcherStrings = [KWBeMemberOfClassMatcher matcherStrings];
    NSArray *expectedStrings = @[@"beMemberOfClass:"];
    STAssertEqualObjects([matcherStrings sortedArrayUsingSelector:@selector(compare:)],
                         [expectedStrings sortedArrayUsingSelector:@selector(compare:)],
                         @"expected specific matcher strings");
}

- (void)testItShouldMatchMembersOfAClass {
    id subject = [Cruiser cruiser];
    id matcher = [KWBeMemberOfClassMatcher matcherWithSubject:subject];
    [matcher beMemberOfClass:[Cruiser class]];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchNonMembersOfAClass {
    id subject = [Cruiser cruiser];
    id matcher = [KWBeMemberOfClassMatcher matcherWithSubject:subject];
    [matcher beMemberOfClass:[Fighter class]];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldHaveHumanReadableDescription
{
  id matcher = [KWBeMemberOfClassMatcher matcherWithSubject:nil];
  [matcher beMemberOfClass:[Cruiser class]];
  STAssertEqualObjects(@"be member of Cruiser", [matcher description], @"description should match");
}

- (void)testItShouldHaveInformativeFailureMessageForShould
{
    id subject = [Cruiser cruiser];
    id matcher = [KWBeMemberOfClassMatcher matcherWithSubject:subject];
    [matcher beMemberOfClass:[Fighter class]];
    STAssertEqualObjects([matcher failureMessageForShould], @"expected subject to be member of Fighter, got Cruiser", @"failure message should match");
}

- (void)testItShouldHaveInformativeFailureMessageForShouldNot
{
    id subject = [Cruiser cruiser];
    id matcher = [KWBeMemberOfClassMatcher matcherWithSubject:subject];
    [matcher beMemberOfClass:[Fighter class]];
    STAssertEqualObjects([matcher failureMessageForShouldNot], @"expected subject not to be member of Fighter, got Cruiser", @"failure message should match");
}

@end

#endif // #if KW_TESTS_ENABLED
