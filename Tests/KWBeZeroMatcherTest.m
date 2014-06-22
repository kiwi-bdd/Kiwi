//
// Licensed under the terms in License.txt
//
// Created by Stewart Gleadow on 12/02/14.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWBeZeroMatcherTest : XCTestCase

@end

@implementation KWBeZeroMatcherTest

- (void)testItShouldHaveTheRightMatcherStrings {
    NSArray *matcherStrings = [KWBeZeroMatcher matcherStrings];
    NSArray *expectedStrings = @[@"beZero"];
    XCTAssertEqualObjects(matcherStrings, expectedStrings, @"expected beZero in the matcher strings");
}

- (void)testItShouldNotMatchNil {
    KWBeZeroMatcher *matcher = [KWBeZeroMatcher matcherWithSubject:nil];
    [matcher beZero];
    XCTAssertFalse([matcher evaluate], @"expected negative match for nil subject");
}

- (void)testItShouldMatchZeroAsAPrimitive {
    id subject = [KWValue valueWithInt:0];
    KWBeZeroMatcher *matcher = [KWBeZeroMatcher matcherWithSubject:subject];
    [matcher beZero];
    XCTAssertTrue([matcher evaluate], @"expected positive match for zero as a value");
}

- (void)testItShouldNotMatchNonZeroPrimitiveValues {
    id subject = [KWValue valueWithInt:42];
    KWBeZeroMatcher *matcher = [KWBeZeroMatcher matcherWithSubject:subject];
    [matcher beZero];
    XCTAssertFalse([matcher evaluate], @"expected negative match for primitive non-zero value");
}

- (void)testItShouldMatchZeroAsAnNSNumber {
    id subject = @0;
    KWBeZeroMatcher *matcher = [KWBeZeroMatcher matcherWithSubject:subject];
    [matcher beZero];
    XCTAssertTrue([matcher evaluate], @"expected positive match for zero as an NSNumber");
}

- (void)testItShouldNotMatchNonZeroNSNumberValues {
    id subject = @42;
    KWBeZeroMatcher *matcher = [KWBeZeroMatcher matcherWithSubject:subject];
    [matcher beZero];
    XCTAssertFalse([matcher evaluate], @"expected negative match for non-zero NSNumber values");
}

- (void)testItShouldHaveHumanReadableDescription {
    KWBeZeroMatcher *matcher = [KWBeZeroMatcher matcherWithSubject:nil];
    XCTAssertEqualObjects(@"be zero", [matcher description], @"description should match");
}

@end

#endif // #if KW_TESTS_ENABLED
