//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWBeSubclassOfClassMatcherTest : XCTestCase

@end

@implementation KWBeSubclassOfClassMatcherTest

- (void)testItShouldHaveTheRightMatcherStrings {
    NSArray *matcherStrings = [KWBeSubclassOfClassMatcher matcherStrings];
    NSArray *expectedStrings = @[@"beSubclassOfClass:"];
    XCTAssertEqualObjects([matcherStrings sortedArrayUsingSelector:@selector(compare:)],
                          [expectedStrings sortedArrayUsingSelector:@selector(compare:)],
                          @"expected specific matcher strings");
}

- (void)testItShouldMatchSubclassesOfAClass {
    id subject = [Cruiser class];
    id matcher = [KWBeSubclassOfClassMatcher matcherWithSubject:subject];
    [matcher beSubclassOfClass:[Cruiser class]];
    XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchNonSubclassesOfAClass {
    id subject = [Cruiser class];
    id matcher = [KWBeSubclassOfClassMatcher matcherWithSubject:subject];
    [matcher beSubclassOfClass:[Fighter class]];
    XCTAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldHaveHumanReadableDescription
{
    id matcher = [KWBeSubclassOfClassMatcher matcherWithSubject:nil];
    [matcher beSubclassOfClass:[Cruiser class]];
    XCTAssertEqualObjects(@"be subclass of Cruiser", [matcher description], @"description should match");
}

- (void)testItShouldHaveInformativeFailureMessageForShould
{
    id subject = [Cruiser cruiser];
    id matcher = [KWBeSubclassOfClassMatcher matcherWithSubject:subject];
    [matcher beSubclassOfClass:[Fighter class]];
    XCTAssertEqualObjects([matcher failureMessageForShould], @"expected subject to be subclass of Fighter, got Cruiser", @"failure message should match");
}

- (void)testItShouldHaveInformativeFailureMessageForShouldNot
{
    id subject = [Cruiser cruiser];
    id matcher = [KWBeSubclassOfClassMatcher matcherWithSubject:subject];
    [matcher beSubclassOfClass:[Fighter class]];
    XCTAssertEqualObjects([matcher failureMessageForShouldNot], @"expected subject not to be subclass of Fighter, got Cruiser", @"failure message should match");
}

@end

#endif // #if KW_TESTS_ENABLED
