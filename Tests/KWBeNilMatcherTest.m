//
//  KWBeNilMatcherTest.m
//  Kiwi
//
//  Created by Marin Usalj on 6/28/13.
//  Copyright 2013 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWBeNilMatcherTest : SenTestCase

@end

@implementation KWBeNilMatcherTest

- (void)testItShouldHaveTheRightMatcherStrings {
    NSArray *matcherStrings = [KWBeNilMatcher matcherStrings];
    NSArray *expectedStrings = @[@"beNil", @"beNil:"];
    STAssertEqualObjects([matcherStrings sortedArrayUsingSelector:@selector(compare:)],
                         [expectedStrings sortedArrayUsingSelector:@selector(compare:)],
                         @"expected specific matcher strings");
}

- (void)testItShouldMatchNils {
    id subject = nil;
    id matcher = [KWBeNilMatcher matcherWithSubject:subject];
    [matcher beNil];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchNonNils {
    id subject = [Cruiser cruiser];
    id matcher = [KWBeNilMatcher matcherWithSubject:subject];
    [matcher beNil];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldHaveHumanReadableDescription {
    id matcher = [KWBeNilMatcher matcherWithSubject:nil];
    STAssertEqualObjects(@"be nil", [matcher description], @"description should match");
}

- (void)testItShouldHaveInformativeFailureMessageForShould {
    id subject = [Cruiser cruiser];
    id matcher = [KWBeNilMatcher matcherWithSubject:subject];
    NSString *failure = [NSString stringWithFormat:@"expected subject to be nil, got %@", subject];
    STAssertEqualObjects([matcher failureMessageForShould], failure, @"failure message should match");
}

- (void)testItShouldHaveInformativeFailureMessageForShouldNot {
    id subject = [Cruiser cruiser];
    id matcher = [KWBeNilMatcher matcherWithSubject:subject];
    NSString *failure = [NSString stringWithFormat:@"expected %@ not to be nil", subject];
    STAssertEqualObjects([matcher failureMessageForShouldNot], failure, @"failure message should match");
}

@end

#endif // #if KW_TESTS_ENABLED
