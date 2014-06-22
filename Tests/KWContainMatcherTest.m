//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWContainMatcherTest : XCTestCase

@end

@implementation KWContainMatcherTest

- (void)testItShouldHaveTheRightMatcherStrings {
    NSArray *matcherStrings = [KWContainMatcher matcherStrings];
    NSArray *expectedStrings = @[@"contain:", @"containObjectsInArray:"];
    XCTAssertEqualObjects([matcherStrings sortedArrayUsingSelector:@selector(compare:)],
                          [expectedStrings sortedArrayUsingSelector:@selector(compare:)],
                          @"expected specific matcher strings");
}

- (void)testItShouldRaiseWhenTheSubjectIsInvalid {
    id subject = [[[NSObject alloc] init] autorelease];
    id matcher = [KWContainMatcher matcherWithSubject:subject];
    [matcher contain:@"liger"];
    XCTAssertThrowsSpecificNamed([matcher evaluate], NSException, @"KWMatcherException", @"expected raised exception");
}

- (void)testItShouldMatchContainedElements {
    id subject = @[@"dog", @"cat", @"tiger", @"liger"];
    id matcher = [KWContainMatcher matcherWithSubject:subject];
    [matcher contain:@"liger"];
    XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testitShouldNotMatchNonContainedElements {
    id subject = @[@"dog", @"cat", @"tiger", @"liger"];
    id matcher = [KWContainMatcher matcherWithSubject:subject];
    [matcher contain:@"lion"];
    XCTAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldMatchContainedArrayObjects {
    id subject = @[@"dog", @"cat", @"tiger", @"liger"];
    id objects = @[@"cat", @"liger"];
    id matcher = [KWContainMatcher matcherWithSubject:subject];
    [matcher containObjectsInArray:objects];
    XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchNonContainedArrayObjects {
    id subject = @[@"dog", @"cat", @"tiger", @"liger"];
    id objects = @[@"cat", @"lion"];
    id matcher = [KWContainMatcher matcherWithSubject:subject];
    [matcher containObjectsInArray:objects];
    XCTAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldMatchContainedElementsWithGenericMatcher
{
    id subject = @[@"dog", @"cat", @"tiger", @"liger"];
    id matcher = [KWContainMatcher matcherWithSubject:subject];
    [matcher contain:hasPrefix(@"li")];
    XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchContainedElementsWithGenericMatcher
{
    id subject = @[@"dog", @"cat", @"tiger", @"liger"];
    id matcher = [KWContainMatcher matcherWithSubject:subject];
    [matcher contain:hasPrefix(@"ele")];
    XCTAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldHaveHumanReadableDescription
{
    id matcher = [KWContainMatcher matcherWithSubject:nil];

    [matcher contain:@"liger"];
    XCTAssertEqualObjects(@"contain \"liger\"", [matcher description], @"description should match");

    [matcher containObjectsInArray:@[@"cat", @"lion"]];
    XCTAssertEqualObjects(@"contain all of (\"cat\", \"lion\")", [matcher description], @"description should match");

    [matcher contain:hasPrefix(@"ele")];
    XCTAssertEqualObjects(@"contain a string with prefix 'ele'", [matcher description], @"description should match");
}

@end

#endif // #if KW_TESTS_ENABLED
