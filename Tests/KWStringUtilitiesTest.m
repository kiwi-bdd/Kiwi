//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"

#if KW_TESTS_ENABLED

@interface KWStringUtilitiesTest : SenTestCase

@end

@implementation KWStringUtilitiesTest

- (void)testItShouldDetectStringsWithStrictWordPrefixes {
    NSString *string = @"KWEqualMatcher";
    NSString *prefix = @"KW";
    STAssertTrue(KWStringHasStrictWordPrefix(string, prefix), @"expected string to pass test");

    string = @"KWarElephant";
    STAssertFalse(KWStringHasStrictWordPrefix(string, prefix), @"expected string to fail test");

    string = @"itShouldOpenDoors";
    prefix = @"it";
    STAssertTrue(KWStringHasStrictWordPrefix(string, prefix), @"expected string to pass test");

    string = @"itsyBitsy";
    STAssertFalse(KWStringHasStrictWordPrefix(string, prefix), @"expected string to fail test");
}

- (void)testItShouldDetectStringsWithWords {
    STAssertTrue(KWStringHasWord(@"copy", @"copy"), @"expected string to pass test");
    STAssertTrue(KWStringHasWord(@"mutableCopy", @"Copy"), @"expected string to pass test");
    STAssertTrue(KWStringHasWord(@"mutableCopyWithAccoutrement", @"Copy"), @"expected string to pass test");
    STAssertFalse(KWStringHasWord(@"copyright", @"copy"), @"expected string to pass test");
    STAssertFalse(KWStringHasWord(@"rightcopy", @"copy"), @"expected string to pass test");
    STAssertFalse(KWStringHasWord(@"copyright", @"copy"), @"expected string to pass test");
}

@end

#endif // #if KW_TESTS_ENABLED
