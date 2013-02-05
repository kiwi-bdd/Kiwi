//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "NSInvocation+KiwiAdditions.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWHaveMatcherTest : SenTestCase

@end

@implementation KWHaveMatcherTest

- (void)testItShouldHaveTheRightMatcherStrings {
    NSArray *matcherStrings = [KWHaveMatcher matcherStrings];
    NSArray *expectedStrings = @[@"haveCountOf:",
                                                         @"haveCountOfAtLeast:",
                                                         @"haveCountOfAtMost:",
                                                         @"have:itemsForInvocation:",
                                                         @"haveAtLeast:itemsForInvocation:",
                                                         @"haveAtMost:itemsForInvocation:"];
    STAssertEqualObjects([matcherStrings sortedArrayUsingSelector:@selector(compare:)],
                         [expectedStrings sortedArrayUsingSelector:@selector(compare:)],
                         @"expected specific matcher strings");
}

- (void)testItShouldMatchExactCounts {
    id subject = @[@"dog", @"cat", @"tiger", @"liger"];
    id matcher = [KWHaveMatcher matcherWithSubject:subject];
    [matcher haveCountOf:4];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchNonExactCounts {
    id subject = @[@"dog", @"cat", @"tiger", @"liger"];
    id matcher = [KWHaveMatcher matcherWithSubject:subject];
    [matcher haveCountOf:3];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldMatchAtLeastCounts {
    id subject = @[@"dog", @"cat", @"tiger", @"liger"];
    id matcher = [KWHaveMatcher matcherWithSubject:subject];
    [matcher haveCountOfAtLeast:3];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldMatchAtMostCounts {
    id subject = @[@"dog", @"cat", @"tiger", @"liger"];
    id matcher = [KWHaveMatcher matcherWithSubject:subject];
    [matcher haveCountOfAtMost:5];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldMatchExactCountsForInvocation {
    id subject = [Cruiser cruiser];
    [subject setFighters:@[[Fighter fighterWithCallsign:@"Viper 1"],
                                                   [Fighter fighterWithCallsign:@"Viper 2"],
                                                   [Fighter fighterWithCallsign:@"Viper 3"]]];
    NSInvocation *invocation = [NSInvocation invocationWithTarget:subject selector:@selector(fighters)];
    id matcher = [KWHaveMatcher matcherWithSubject:subject];
    [matcher have:3 itemsForInvocation:invocation];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldMatchAtLeastCountsForInvocation {
    id subject = [Cruiser cruiser];
    [subject setFighters:@[[Fighter fighterWithCallsign:@"Viper 1"],
                                                   [Fighter fighterWithCallsign:@"Viper 2"],
                                                   [Fighter fighterWithCallsign:@"Viper 3"]]];
    NSInvocation *invocation = [NSInvocation invocationWithTarget:subject selector:@selector(fighters)];
    id matcher = [KWHaveMatcher matcherWithSubject:subject];
    [matcher haveAtLeast:2 itemsForInvocation:invocation];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldMatchAtMostCountsForInvocation {
    id subject = [Cruiser cruiser];
    [subject setFighters:@[[Fighter fighterWithCallsign:@"Viper 1"],
                                                   [Fighter fighterWithCallsign:@"Viper 2"],
                                                   [Fighter fighterWithCallsign:@"Viper 3"]]];
    NSInvocation *invocation = [NSInvocation invocationWithTarget:subject selector:@selector(fighters)];
    id matcher = [KWHaveMatcher matcherWithSubject:subject];
    [matcher haveAtMost:4 itemsForInvocation:invocation];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldRaiseWhenInvocationDoesNotReturnAnObject {
    id subject = [Cruiser cruiser];
    NSInvocation *invocation = [NSInvocation invocationWithTarget:subject selector:@selector(crewComplement)];
    id matcher = [KWHaveMatcher matcherWithSubject:subject];
    [matcher have:1010 itemsForInvocation:invocation];
    STAssertThrows([matcher evaluate], @"expected raised exception");
}

- (void)testItShouldTreatNilTargetObjectsAsEmptyCollections {
    id subject = [Cruiser cruiser];
    NSInvocation *invocation = [NSInvocation invocationWithTarget:subject selector:@selector(fighters)];
    id matcher = [KWHaveMatcher matcherWithSubject:subject];
    [matcher have:0 itemsForInvocation:invocation];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldHaveHumanReadableDescription
{
    id matcher = [KWHaveMatcher matcherWithSubject:nil];

    // simple matchers

    [matcher haveCountOf:3];
    STAssertEqualObjects([matcher description], @"have 3 items", @"should have correct description");

    [matcher haveCountOfAtLeast:3];
    STAssertEqualObjects([matcher description], @"have at least 3 items", @"should have correct description");

    [matcher haveCountOfAtMost:3];
    STAssertEqualObjects([matcher description], @"have at most 3 items", @"should have correct description");

    // invocation matchers

    id subject = [Cruiser cruiser];
    [subject setFighters:@[[Fighter fighterWithCallsign:@"Viper 1"],
                          [Fighter fighterWithCallsign:@"Viper 2"],
                          [Fighter fighterWithCallsign:@"Viper 3"]]];
    NSInvocation *invocation = [NSInvocation invocationWithTarget:subject selector:@selector(fighters)];

    [matcher have:3 itemsForInvocation:invocation];
    STAssertEqualObjects([matcher description], @"have 3 fighters", @"should have correct description");

    [matcher haveAtLeast:3 itemsForInvocation:invocation];
    STAssertEqualObjects([matcher description], @"have at least 3 fighters", @"should have correct description");

    [matcher haveAtMost:3 itemsForInvocation:invocation];
    STAssertEqualObjects([matcher description], @"have at most 3 fighters", @"should have correct description");
}

@end

#endif // #if KW_TESTS_ENABLED
