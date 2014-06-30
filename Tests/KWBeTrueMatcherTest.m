//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWBeTrueMatcherTest : XCTestCase

@end

@implementation KWBeTrueMatcherTest

- (void)testItShouldHaveTheRightMatcherStrings {
    NSArray *matcherStrings = [KWBeTrueMatcher matcherStrings];
    NSArray *expectedStrings = @[@"beTrue", @"beFalse", @"beYes", @"beNo"];
    XCTAssertEqualObjects([matcherStrings sortedArrayUsingSelector:@selector(compare:)],
                          [expectedStrings sortedArrayUsingSelector:@selector(compare:)],
                          @"expected specific matcher strings");
}

- (void)testItShouldRaiseWhenTheSubjectIsInvalid {
    id subject = @[];
    KWBeTrueMatcher *matcher = [KWBeTrueMatcher matcherWithSubject:subject];
    [matcher beTrue];
    XCTAssertThrowsSpecificNamed([matcher evaluate], NSException, @"KWMatcherException", @"expected raised exception");
}

- (void)testItShouldMatchTrueObjectsToBeTrue {
    id subject = [KWValue valueWithBool:YES];
    KWBeTrueMatcher *matcher = [KWBeTrueMatcher matcherWithSubject:subject];
    [matcher beTrue];
    XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchFalseObjectsToBeTrue {
    id subject = [KWValue valueWithBool:NO];
    KWBeTrueMatcher *matcher = [KWBeTrueMatcher matcherWithSubject:subject];
    [matcher beTrue];
    XCTAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldNotMatchTrueObjectsToBeFalse {
    id subject = [KWValue valueWithBool:YES];
    KWBeTrueMatcher *matcher = [KWBeTrueMatcher matcherWithSubject:subject];
    [matcher beFalse];
    XCTAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldMatchFalseObjectsToBeFalse {
    id subject = [KWValue valueWithBool:NO];
    KWBeTrueMatcher *matcher = [KWBeTrueMatcher matcherWithSubject:subject];
    [matcher beFalse];
    XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldHaveHumanReadableDescription
{
  KWBeTrueMatcher *matcher = [KWBeTrueMatcher matcherWithSubject:nil];
  [matcher beTrue];
  XCTAssertEqualObjects(@"be true", [matcher description], @"description should match");
  [matcher beFalse];
  XCTAssertEqualObjects(@"be false", [matcher description], @"description should match");
}

@end

#endif // #if KW_TESTS_ENABLED
