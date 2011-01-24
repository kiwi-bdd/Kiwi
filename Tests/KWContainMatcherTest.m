//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWContainMatcherTest : SenTestCase

@end

@implementation KWContainMatcherTest

- (void)testItShouldHaveTheRightMatcherStrings {
    NSArray *matcherStrings = [KWContainMatcher matcherStrings];
    NSArray *expectedStrings = [NSArray arrayWithObjects:@"contain:", @"containObjectsInArray:", nil];
    STAssertEqualObjects([matcherStrings sortedArrayUsingSelector:@selector(compare:)],
                         [expectedStrings sortedArrayUsingSelector:@selector(compare:)],
                         @"expected specific matcher strings");
}

- (void)testItShouldRaiseWhenTheSubjectIsInvalid {
    id subject = [[[NSObject alloc] init] autorelease];
    id matcher = [KWContainMatcher matcherWithSubject:subject];
    [matcher contain:@"liger"];
    STAssertThrowsSpecificNamed([matcher evaluate], NSException, @"KWMatcherException", @"expected raised exception");
}

- (void)testItShouldMatchContainedElements {
    id subject = [NSArray arrayWithObjects:@"dog", @"cat", @"tiger", @"liger", nil];
    id matcher = [KWContainMatcher matcherWithSubject:subject];
    [matcher contain:@"liger"];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testitShouldNotMatchNonContainedElements {
    id subject = [NSArray arrayWithObjects:@"dog", @"cat", @"tiger", @"liger", nil];
    id matcher = [KWContainMatcher matcherWithSubject:subject];
    [matcher contain:@"lion"];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldMatchContainedArrayObjects {
    id subject = [NSArray arrayWithObjects:@"dog", @"cat", @"tiger", @"liger", nil];
    id objects = [NSArray arrayWithObjects:@"cat", @"liger", nil];
    id matcher = [KWContainMatcher matcherWithSubject:subject];
    [matcher containObjectsInArray:objects];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchNonContainedArrayObjects {
    id subject = [NSArray arrayWithObjects:@"dog", @"cat", @"tiger", @"liger", nil];
    id objects = [NSArray arrayWithObjects:@"cat", @"lion", nil];
    id matcher = [KWContainMatcher matcherWithSubject:subject];
    [matcher containObjectsInArray:objects];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldMatchContainedElementsWithHamcrestMatcher
{
    id subject = [NSArray arrayWithObjects:@"dog", @"cat", @"tiger", @"liger", nil];
    id matcher = [KWContainMatcher matcherWithSubject:subject];
    [matcher contain:hasPrefix(@"li")];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchContainedElementsWithHamcrestMatcher
{
    id subject = [NSArray arrayWithObjects:@"dog", @"cat", @"tiger", @"liger", nil];
    id matcher = [KWContainMatcher matcherWithSubject:subject];
    [matcher contain:hasPrefix(@"ele")];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

@end

#endif // #if KW_TESTS_ENABLED
