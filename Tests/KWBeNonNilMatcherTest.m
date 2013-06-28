//
//  KWBeNonNilMatcherTest.m
//  Kiwi
//
//  Created by Marin Usalj on 6/28/13.
//  Copyright 2013 Allen Ding. All rights reserved.
//


#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWBeNonNilMatcherTest : SenTestCase

@end

@implementation KWBeNonNilMatcherTest

- (void)testItShouldHaveTheRightMatcherStrings {
    NSArray *matcherStrings = [KWBeNonNilMatcher matcherStrings];
    NSArray *expectedStrings = @[@"beNonNil", @"beNonNil:"];
    STAssertEqualObjects([matcherStrings sortedArrayUsingSelector:@selector(compare:)],
                         [expectedStrings sortedArrayUsingSelector:@selector(compare:)],
                         @"expected specific matcher strings");
}

- (void)testItShouldMatchNonNils {
    id subject = [Cruiser cruiser];
    id matcher = [KWBeNonNilMatcher matcherWithSubject:subject];
    [matcher beNonNil];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchNils {
    id subject = nil;
    id matcher = [KWBeNonNilMatcher matcherWithSubject:subject];
    [matcher beNonNil];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldHaveHumanReadableDescription {
    id matcher = [KWBeNonNilMatcher matcherWithSubject:nil];
    STAssertEqualObjects(@"be non-nil", [matcher description], @"description should match");
}

- (void)testItShouldHaveInformativeFailureMessageForShould {
    id subject = [Cruiser cruiser];
    id matcher = [KWBeNonNilMatcher matcherWithSubject:subject];
    STAssertEqualObjects([matcher failureMessageForShould], @"expected subject to be non-nil", @"failure message should match");
}

- (void)testItShouldHaveInformativeFailureMessageForShouldNot {
    id subject = [Cruiser cruiser];
    id matcher = [KWBeNonNilMatcher matcherWithSubject:subject];
    NSString *failure = [NSString stringWithFormat:@"expected %@ to be nil", subject];
    STAssertEqualObjects([matcher failureMessageForShouldNot], failure, @"failure message should match");
}

@end

#endif // #if KW_TESTS_ENABLED
