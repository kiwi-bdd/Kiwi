//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWBlockRaiseMatcherTest : XCTestCase

@end

@implementation KWBlockRaiseMatcherTest

- (void)testItShouldHaveTheRightMatcherStrings {
    NSArray *matcherStrings = [KWBlockRaiseMatcher matcherStrings];
    NSArray *expectedStrings = @[@"raise",
                                                         @"raiseWithName:",
                                                         @"raiseWithReason:",
                                                         @"raiseWithName:reason:"];
    XCTAssertEqualObjects([matcherStrings sortedArrayUsingSelector:@selector(compare:)],
                          [expectedStrings sortedArrayUsingSelector:@selector(compare:)],
                          @"expected specific matcher strings");
}

- (void)testItShouldMatchForRaisingBlocks {
    id cruiser = [Cruiser cruiser];
    id subject = [KWBlock blockWithBlock:^{ [cruiser raise]; }];
    KWBlockRaiseMatcher *matcher = [KWBlockRaiseMatcher matcherWithSubject:subject];
    [matcher raise];
    XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchForNonRaisingBlocks {
    id cruiser = [Cruiser cruiser];
    id subject = [KWBlock blockWithBlock:^{ [cruiser raiseShields]; }];
    KWBlockRaiseMatcher *matcher = [KWBlockRaiseMatcher matcherWithSubject:subject];
    [matcher raise];
    XCTAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldHaveHumanReadableDescription
{
    KWBlockRaiseMatcher *matcher = [KWBlockRaiseMatcher matcherWithSubject:nil];
    XCTAssertEqualObjects(@"raise nothing", [matcher description], @"description should match");

    [matcher raise];
    XCTAssertEqualObjects(@"raise exception", [matcher description], @"description should match");

    [matcher raiseWithName:@"DummyException"];
    XCTAssertEqualObjects(@"raise DummyException", [matcher description], @"description should match");

    [matcher raiseWithReason:@"for testing purposes"];
    XCTAssertEqualObjects(@"raise exception \"for testing purposes\"", [matcher description], @"description should match");

    [matcher raiseWithName:@"DummyException" reason:@"for testing purposes"];
    XCTAssertEqualObjects(@"raise DummyException \"for testing purposes\"", [matcher description], @"description should match");
}

@end

#endif // #if KW_TESTS_ENABLED