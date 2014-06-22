//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWConformToProtocolMatcherTest : XCTestCase

@end

@implementation KWConformToProtocolMatcherTest

- (void)testItShouldHaveTheRightMatcherStrings {
    NSArray *matcherStrings = [KWConformToProtocolMatcher matcherStrings];
    NSArray *expectedStrings = @[@"conformToProtocol:"];
    XCTAssertEqualObjects([matcherStrings sortedArrayUsingSelector:@selector(compare:)],
                          [expectedStrings sortedArrayUsingSelector:@selector(compare:)],
                          @"expected specific matcher strings");
}

- (void)testItShouldMatchConformingObjects {
    id subject = [Cruiser cruiser];
    KWConformToProtocolMatcher *matcher = [KWConformToProtocolMatcher matcherWithSubject:subject];
    [matcher conformToProtocol:@protocol(JumpCapable)];
    XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchNonConformingObjects {
    id subject = [Fighter fighter];
    KWConformToProtocolMatcher *matcher = [KWConformToProtocolMatcher matcherWithSubject:subject];
    [matcher conformToProtocol:@protocol(JumpCapable)];
    XCTAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldHaveHumanReadableDescription
{
    KWConformToProtocolMatcher *matcher = [KWConformToProtocolMatcher matcherWithSubject:nil];
    [matcher conformToProtocol:@protocol(JumpCapable)];
    XCTAssertEqualObjects(@"conform to JumpCapable protocol", [matcher description], @"description should match");
}

@end

#endif // #if KW_TESTS_ENABLED
