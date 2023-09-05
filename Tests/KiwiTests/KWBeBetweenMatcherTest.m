//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWBeBetweenMatcherTest : XCTestCase

@end

@implementation KWBeBetweenMatcherTest

- (void)testItShouldHaveTheRightMatcherStrings {
    NSArray *matcherStrings = [KWBeBetweenMatcher matcherStrings];
    NSArray *expectedStrings = @[@"beBetween:and:", @"beInTheIntervalFrom:to:"];
    XCTAssertEqualObjects([matcherStrings sortedArrayUsingSelector:@selector(compare:)],
                          [expectedStrings sortedArrayUsingSelector:@selector(compare:)],
                          @"expected specific matcher strings");
}

- (void)testItShouldMatchIncludedElements {
    id subject = [KWValue valueWithInt:42];
    KWBeBetweenMatcher *matcher = [KWBeBetweenMatcher matcherWithSubject:subject];
    [matcher beBetween:[KWValue valueWithInt:40] and:[KWValue valueWithInt:50]];
    XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchIncludedElements {
    id subject = [KWValue valueWithInt:42];
    KWBeBetweenMatcher *matcher = [KWBeBetweenMatcher matcherWithSubject:subject];
    [matcher beBetween:[KWValue valueWithInt:50] and:[KWValue valueWithInt:60]];
    XCTAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldHaveHumanReadableDescription
{
  KWBeBetweenMatcher *matcher = [KWBeBetweenMatcher matcherWithSubject:[KWValue valueWithInt:0]];
  [matcher beBetween:[KWValue valueWithInt:10] and:[KWValue valueWithInt:20]];
  XCTAssertEqualObjects([matcher description], @"be between 10 and 20", @"expected description to match");
}

@end

#endif // #if KW_TESTS_ENABLED
