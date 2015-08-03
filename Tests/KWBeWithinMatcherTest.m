//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWBeWithinMatcherTest : XCTestCase

@end

@implementation KWBeWithinMatcherTest

- (void)testItShouldHaveTheRightMatcherStrings {
    NSArray *matcherStrings = [KWBeWithinMatcher matcherStrings];
    NSArray *expectedStrings = @[@"beWithin:of:", @"equal:withDelta:"];
    XCTAssertEqualObjects([matcherStrings sortedArrayUsingSelector:@selector(compare:)],
                          [expectedStrings sortedArrayUsingSelector:@selector(compare:)],
                          @"expected specific matcher strings");
}

- (void)testItShouldMatchCloseObjects {
    id subject = [KWValue valueWithInt:42];
    KWBeWithinMatcher *matcher = [KWBeWithinMatcher matcherWithSubject:subject];
    [matcher beWithin:[KWValue valueWithInt:2] of:[KWValue valueWithInt:40]];
    XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchNonCloseObjects {
    id subject = [KWValue valueWithInt:42];
    KWBeWithinMatcher *matcher = [KWBeWithinMatcher matcherWithSubject:subject];
    [matcher beWithin:[KWValue valueWithInt:1] of:[KWValue valueWithInt:40]];
    XCTAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldHaveHumanReadableDescription
{
  KWBeWithinMatcher *matcher = [KWBeWithinMatcher matcherWithSubject:nil];
  [matcher beWithin:[KWValue valueWithInt:1] of:[KWValue valueWithInt:40]];
  XCTAssertEqualObjects(@"be within 1 of 40", [matcher description], @"description should match");
}

@end

#endif // #if KW_TESTS_ENABLED
