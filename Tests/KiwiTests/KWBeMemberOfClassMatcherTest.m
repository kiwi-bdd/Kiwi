//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWBeMemberOfClassMatcherTest : XCTestCase

@end

@implementation KWBeMemberOfClassMatcherTest

- (void)testItShouldHaveTheRightMatcherStrings {
    NSArray *matcherStrings = [KWBeMemberOfClassMatcher matcherStrings];
    NSArray *expectedStrings = @[@"beMemberOfClass:"];
    XCTAssertEqualObjects([matcherStrings sortedArrayUsingSelector:@selector(compare:)],
                          [expectedStrings sortedArrayUsingSelector:@selector(compare:)],
                          @"expected specific matcher strings");
}

- (void)testItShouldMatchMembersOfAClass {
    id subject = [Cruiser new];
    KWBeMemberOfClassMatcher *matcher = [KWBeMemberOfClassMatcher matcherWithSubject:subject];
    [matcher beMemberOfClass:[Cruiser class]];
    XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchNonMembersOfAClass {
    id subject = [Cruiser new];
    KWBeMemberOfClassMatcher *matcher = [KWBeMemberOfClassMatcher matcherWithSubject:subject];
    [matcher beMemberOfClass:[Fighter class]];
    XCTAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldHaveHumanReadableDescription
{
  KWBeMemberOfClassMatcher *matcher = [KWBeMemberOfClassMatcher matcherWithSubject:nil];
  [matcher beMemberOfClass:[Cruiser class]];
  XCTAssertEqualObjects(@"be member of Cruiser", [matcher description], @"description should match");
}

- (void)testItShouldHaveInformativeFailureMessageForShould
{
    id subject = [Cruiser new];
    KWBeMemberOfClassMatcher *matcher = [KWBeMemberOfClassMatcher matcherWithSubject:subject];
    [matcher beMemberOfClass:[Fighter class]];
    XCTAssertEqualObjects([matcher failureMessageForShould], @"expected subject to be member of Fighter, got Cruiser", @"failure message should match");
}

- (void)testItShouldHaveInformativeFailureMessageForShouldNot
{
    id subject = [Cruiser new];
    KWBeMemberOfClassMatcher *matcher = [KWBeMemberOfClassMatcher matcherWithSubject:subject];
    [matcher beMemberOfClass:[Fighter class]];
    XCTAssertEqualObjects([matcher failureMessageForShouldNot], @"expected subject not to be member of Fighter, got Cruiser", @"failure message should match");
}

@end

#endif // #if KW_TESTS_ENABLED
