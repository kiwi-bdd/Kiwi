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
    NSArray *expectedStrings = [NSArray arrayWithObjects:@"raiseWhenSent:",
                                                         @"raiseWithName:whenSent:",
                                                         @"raiseWithReason:whenSent:",
                                                         @"raiseWithName:reason:whenSent:", nil];
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

@end

#endif // #if KW_TESTS_ENABLED
