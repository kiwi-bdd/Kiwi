//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWBeTrueMatcherTest : SenTestCase

@end

@implementation KWBeTrueMatcherTest

- (void)testItShouldHaveTheRightMatcherStrings {
    NSArray *matcherStrings = [KWBeTrueMatcher matcherStrings];
    NSArray *expectedStrings = @[@"beTrue", @"beFalse", @"beYes", @"beNo"];
    STAssertEqualObjects([matcherStrings sortedArrayUsingSelector:@selector(compare:)],
                         [expectedStrings sortedArrayUsingSelector:@selector(compare:)],
                         @"expected specific matcher strings");
}

- (void)testItShouldRaiseWhenTheSubjectIsInvalid {
    id subject = @[];
    id matcher = [KWBeTrueMatcher matcherWithSubject:subject];
    [matcher beTrue];
    STAssertThrowsSpecificNamed([matcher evaluate], NSException, @"KWMatcherException", @"expected raised exception");
}

- (void)testItShouldMatchTrueObjectsToBeTrue {
    id subject = [KWValue valueWithBool:YES];
    id matcher = [KWBeTrueMatcher matcherWithSubject:subject];
    [matcher beTrue];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchFalseObjectsToBeTrue {
    id subject = [KWValue valueWithBool:NO];
    id matcher = [KWBeTrueMatcher matcherWithSubject:subject];
    [matcher beTrue];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldNotMatchTrueObjectsToBeFalse {
    id subject = [KWValue valueWithBool:YES];
    id matcher = [KWBeTrueMatcher matcherWithSubject:subject];
    [matcher beFalse];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldMatchFalseObjectsToBeFalse {
    id subject = [KWValue valueWithBool:NO];
    id matcher = [KWBeTrueMatcher matcherWithSubject:subject];
    [matcher beFalse];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldHaveHumanReadableDescription
{
  id matcher = [KWBeTrueMatcher matcherWithSubject:nil];
  [matcher beTrue];
  STAssertEqualObjects(@"be true", [matcher description], @"description should match");
  [matcher beFalse];
  STAssertEqualObjects(@"be false", [matcher description], @"description should match");
}

@end

#endif // #if KW_TESTS_ENABLED
