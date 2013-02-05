//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWRaiseMatcherTest : SenTestCase

@end

@implementation KWRaiseMatcherTest

- (void)testItShouldHaveTheRightMatcherStrings {
    NSArray *matcherStrings = [KWRaiseMatcher matcherStrings];
    NSArray *expectedStrings = @[@"raiseWhenSent:",
                                                         @"raiseWithName:whenSent:",
                                                         @"raiseWithReason:whenSent:",
                                                         @"raiseWithName:reason:whenSent:"];
    STAssertEqualObjects([matcherStrings sortedArrayUsingSelector:@selector(compare:)],
                         [expectedStrings sortedArrayUsingSelector:@selector(compare:)],
                         @"expected specific matcher strings");
}

- (void)testItShouldMatchForRaisingSelectors {
    id subject = [Cruiser cruiser];
    id matcher = [KWRaiseMatcher matcherWithSubject:subject];
    [matcher raiseWhenSent:@selector(raise)];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchForNonRaisingSelectors {
    id subject = [Cruiser cruiser];
    id matcher = [KWRaiseMatcher matcherWithSubject:subject];
    [matcher raiseWhenSent:@selector(fighters)];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldMatchNamedExceptionsForRaisingSelectors{
    id subject = [Cruiser cruiser];
    id matcher = [KWRaiseMatcher matcherWithSubject:subject];
    [matcher raiseWithName:@"CruiserException" whenSent:@selector(raise)];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchNamedExceptionsForRaisingSelectors {
    id subject = [Cruiser cruiser];
    id matcher = [KWRaiseMatcher matcherWithSubject:subject];
    [matcher raiseWithName:@"FighterException" whenSent:@selector(raise)];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldMatchNamedDescribedExceptionsForRaisingSelectors {
    id subject = [Cruiser cruiser];
    id matcher = [KWRaiseMatcher matcherWithSubject:subject];
    [matcher raiseWithName:@"CruiserException" reason:@"-[Cruiser raise]" whenSent:@selector(raise)];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchNamedDescribedExceptionsForRaisingSelectors {
    id subject = [Cruiser cruiser];
    id matcher = [KWRaiseMatcher matcherWithSubject:subject];
    [matcher raiseWithName:@"CruiserException" reason:@"-[Fighter raise]" whenSent:@selector(raise)];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldHaveHumanReadableDescription
{
    id matcher = [KWRaiseMatcher matcherWithSubject:theValue(123)];

    [matcher raiseWhenSent:@selector(raise)];
    STAssertEqualObjects(@"raise exception when sent raise", [matcher description], @"description should match");

    [matcher raiseWithName:@"CruiserException" whenSent:@selector(raise)];
    STAssertEqualObjects(@"raise CruiserException when sent raise", [matcher description], @"description should match");

    [matcher raiseWithReason:@"just for testing" whenSent:@selector(raise)];
    STAssertEqualObjects(@"raise exception \"just for testing\" when sent raise", [matcher description], @"description should match");

    [matcher raiseWithName:@"CruiserException" reason:@"just for testing" whenSent:@selector(raise)];
    STAssertEqualObjects(@"raise CruiserException \"just for testing\" when sent raise", [matcher description], @"description should match");
}

@end

#endif // #if KW_TESTS_ENABLED
