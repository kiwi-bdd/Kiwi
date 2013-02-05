//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWBeBetweenMatcherTest : SenTestCase

@end

@implementation KWBeBetweenMatcherTest

- (void)testItShouldHaveTheRightMatcherStrings {
    NSArray *matcherStrings = [KWBeBetweenMatcher matcherStrings];
    NSArray *expectedStrings = @[@"beBetween:and:", @"beInTheIntervalFrom:to:"];
    STAssertEqualObjects([matcherStrings sortedArrayUsingSelector:@selector(compare:)],
                         [expectedStrings sortedArrayUsingSelector:@selector(compare:)],
                         @"expected specific matcher strings");
}

- (void)testItShouldMatchIncludedElements {
    id subject = [KWValue valueWithInt:42];
    id matcher = [KWBeBetweenMatcher matcherWithSubject:subject];
    [matcher beBetween:[KWValue valueWithInt:40] and:[KWValue valueWithInt:50]];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchIncludedElements {
    id subject = [KWValue valueWithInt:42];
    id matcher = [KWBeBetweenMatcher matcherWithSubject:subject];
    [matcher beBetween:[KWValue valueWithInt:50] and:[KWValue valueWithInt:60]];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldHaveHumanReadableDescription
{
  id matcher = [KWBeBetweenMatcher matcherWithSubject:[KWValue valueWithInt:0]];
  [matcher beBetween:[KWValue valueWithInt:10] and:[KWValue valueWithInt:20]];
  STAssertEqualObjects([matcher description], @"be between 10 and 20", @"expected description to match");
}

@end

#endif // #if KW_TESTS_ENABLED
