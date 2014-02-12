//
// Licensed under the terms in License.txt
//
// Created by Stewart Gleadow on 12/02/14.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWBeZeroMatcherTest : SenTestCase

@end

@implementation KWBeZeroMatcherTest

- (void)testItShouldHaveTheRightMatcherStrings {
    NSArray *matcherStrings = [KWBeZeroMatcher matcherStrings];
    NSArray *expectedStrings = @[@"beZero"];
    STAssertEqualObjects(matcherStrings, expectedStrings, @"expected beZero in the matcher strings");
}

- (void)testItShouldNotMatchNil {
    id matcher = [KWBeZeroMatcher matcherWithSubject:nil];
    [matcher beZero];
    STAssertFalse([matcher evaluate], @"expected negative match for nil subject");
}

- (void)testItShouldMatchZeroAsAPrimitive {
    id subject = [KWValue valueWithInt:0];
    id matcher = [KWBeZeroMatcher matcherWithSubject:subject];
    [matcher beZero];
    STAssertTrue([matcher evaluate], @"expected positive match for zero as a value");
}

- (void)testItShouldNotMatchNonZeroPrimitiveValues {
    id subject = [KWValue valueWithInt:42];
    id matcher = [KWBeZeroMatcher matcherWithSubject:subject];
    [matcher beZero];
    STAssertFalse([matcher evaluate], @"expected negative match for primitive non-zero value");
}

- (void)testItShouldMatchZeroAsAnNSNumber {
    id subject = @0;
    id matcher = [KWBeZeroMatcher matcherWithSubject:subject];
    [matcher beZero];
    STAssertTrue([matcher evaluate], @"expected positive match for zero as an NSNumber");
}

- (void)testItShouldNotMatchNonZeroNSNumberValues {
    id subject = @42;
    id matcher = [KWBeZeroMatcher matcherWithSubject:subject];
    [matcher beZero];
    STAssertFalse([matcher evaluate], @"expected negative match for non-zero NSNumber values");
}

- (void)testItShouldHaveHumanReadableDescription {
    id matcher = [KWBeZeroMatcher matcherWithSubject:nil];
    STAssertEqualObjects(@"be zero", [matcher description], @"description should match");
}

@end

#endif // #if KW_TESTS_ENABLED
