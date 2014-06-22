//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"

#if KW_TESTS_ENABLED

@interface KWStringUtilitiesTest : XCTestCase

@end

@implementation KWStringUtilitiesTest

- (void)testItShouldDetectStringsWithStrictWordPrefixes {
    NSString *string = @"KWEqualMatcher";
    NSString *prefix = @"KW";
    XCTAssertTrue(KWStringHasStrictWordPrefix(string, prefix), @"expected string to pass test");

    string = @"KWarElephant";
    XCTAssertFalse(KWStringHasStrictWordPrefix(string, prefix), @"expected string to fail test");

    string = @"itShouldOpenDoors";
    prefix = @"it";
    XCTAssertTrue(KWStringHasStrictWordPrefix(string, prefix), @"expected string to pass test");

    string = @"itsyBitsy";
    XCTAssertFalse(KWStringHasStrictWordPrefix(string, prefix), @"expected string to fail test");
}

- (void)testItShouldDetectStringsWithWords {
    XCTAssertTrue(KWStringHasWord(@"copy", @"copy"), @"expected string to pass test");
    XCTAssertTrue(KWStringHasWord(@"mutableCopy", @"Copy"), @"expected string to pass test");
    XCTAssertTrue(KWStringHasWord(@"mutableCopyWithAccoutrement", @"Copy"), @"expected string to pass test");
    XCTAssertFalse(KWStringHasWord(@"copyright", @"copy"), @"expected string to pass test");
    XCTAssertFalse(KWStringHasWord(@"rightcopy", @"copy"), @"expected string to pass test");
    XCTAssertFalse(KWStringHasWord(@"copyright", @"copy"), @"expected string to pass test");
}

@end

#endif // #if KW_TESTS_ENABLED
