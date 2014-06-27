//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWBeKindOfClassMatcherTest : XCTestCase

@end

@implementation KWBeKindOfClassMatcherTest

- (void)testItShouldHaveTheRightMatcherStrings {
    NSArray *matcherStrings = [KWBeKindOfClassMatcher matcherStrings];
    NSArray *expectedStrings = @[@"beKindOfClass:"];
    XCTAssertEqualObjects([matcherStrings sortedArrayUsingSelector:@selector(compare:)],
                          [expectedStrings sortedArrayUsingSelector:@selector(compare:)],
                          @"expected specific matcher strings");
}

- (void)testItShouldMatchKindOfClass {
    id subject = [Cruiser cruiser];
    KWBeKindOfClassMatcher *matcher = [KWBeKindOfClassMatcher matcherWithSubject:subject];
    [matcher beKindOfClass:[SpaceShip class]];
    XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchNonKindOfClass {
    id subject = [Cruiser cruiser];
    KWBeKindOfClassMatcher *matcher = [KWBeKindOfClassMatcher matcherWithSubject:subject];
    [matcher beKindOfClass:[Fighter class]];
    XCTAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldHaveHumanReadableDescription
{
  KWBeKindOfClassMatcher *matcher = [KWBeKindOfClassMatcher matcherWithSubject:nil];
  [matcher beKindOfClass:[Fighter class]];
  XCTAssertEqualObjects(@"be kind of Fighter", [matcher description], @"description should match");
}

- (void)testItShouldHaveInformativeFailureMessageForShould
{
    id subject = [Cruiser cruiser];
    KWBeKindOfClassMatcher *matcher = [KWBeKindOfClassMatcher matcherWithSubject:subject];
    [matcher beKindOfClass:[Fighter class]];
    XCTAssertEqualObjects([matcher failureMessageForShould], @"expected subject to be kind of Fighter, got Cruiser", @"failure message should match");
}

- (void)testItShouldHaveInformativeFailureMessageForShouldNot
{
    id subject = [Cruiser cruiser];
    KWBeKindOfClassMatcher *matcher = [KWBeKindOfClassMatcher matcherWithSubject:subject];
    [matcher beKindOfClass:[Fighter class]];
    XCTAssertEqualObjects([matcher failureMessageForShouldNot], @"expected subject not to be kind of Fighter, got Cruiser", @"failure message should match");
}

@end

#endif // #if KW_TESTS_ENABLED
