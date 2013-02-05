//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWBlockRaiseMatcherTest : SenTestCase

@end

@implementation KWBlockRaiseMatcherTest

- (void)testItShouldHaveTheRightMatcherStrings {
    NSArray *matcherStrings = [KWBlockRaiseMatcher matcherStrings];
    NSArray *expectedStrings = @[@"raise",
                                                         @"raiseWithName:",
                                                         @"raiseWithReason:",
                                                         @"raiseWithName:reason:"];
    STAssertEqualObjects([matcherStrings sortedArrayUsingSelector:@selector(compare:)],
                         [expectedStrings sortedArrayUsingSelector:@selector(compare:)],
                         @"expected specific matcher strings");
}

- (void)testItShouldMatchForRaisingBlocks {
    id cruiser = [Cruiser cruiser];
    id subject = [KWBlock blockWithBlock:^{ [cruiser raise]; }];
    id matcher = [KWBlockRaiseMatcher matcherWithSubject:subject];
    [matcher raise];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchForNonRaisingBlocks {
    id cruiser = [Cruiser cruiser];
    id subject = [KWBlock blockWithBlock:^{ [cruiser raiseShields]; }];
    id matcher = [KWBlockRaiseMatcher matcherWithSubject:subject];
    [matcher raise];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldHaveHumanReadableDescription
{
    id matcher = [KWBlockRaiseMatcher matcherWithSubject:nil];
    STAssertEqualObjects(@"raise nothing", [matcher description], @"description should match");

    [matcher raise];
    STAssertEqualObjects(@"raise exception", [matcher description], @"description should match");

    [matcher raiseWithName:@"DummyException"];
    STAssertEqualObjects(@"raise DummyException", [matcher description], @"description should match");

    [matcher raiseWithReason:@"for testing purposes"];
    STAssertEqualObjects(@"raise exception \"for testing purposes\"", [matcher description], @"description should match");

    [matcher raiseWithName:@"DummyException" reason:@"for testing purposes"];
    STAssertEqualObjects(@"raise DummyException \"for testing purposes\"", [matcher description], @"description should match");
}

@end

#endif // #if KW_TESTS_ENABLED