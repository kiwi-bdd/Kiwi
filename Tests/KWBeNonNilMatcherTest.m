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

id subject;
id matcher;

- (void)setUp {
    [super setUp];
    subject = [Cruiser cruiser];
    matcher = [KWBeNonNilMatcher matcherWithSubject:subject];
    [matcher beNonNil];
}

- (void)testItShouldHaveTheRightMatcherStrings {
    NSArray *matcherStrings = [KWBeNonNilMatcher matcherStrings];
    NSArray *expectedStrings = @[@"beNonNil", @"beNonNil:"];
    STAssertEqualObjects([matcherStrings sortedArrayUsingSelector:@selector(compare:)],
                         [expectedStrings sortedArrayUsingSelector:@selector(compare:)],
                         @"expected specific matcher strings");
}

- (void)testItShouldMatchNonNils {
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchNils {
    matcher = [KWBeNonNilMatcher matcherWithSubject:nil];
    [matcher beNonNil];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldHaveHumanReadableDescription {
    STAssertEqualObjects(@"be non-nil", [matcher description], @"description should match");
}

- (void)testItShouldHaveInformativeFailureMessageForShould {
    STAssertEqualObjects([matcher failureMessageForShould], @"expected subject to be non-nil", @"failure message should match");
}

- (void)testItShouldHaveInformativeFailureMessageForShouldNot {
    NSString *failure = [NSString stringWithFormat:@"expected %@ to be nil", subject];
    STAssertEqualObjects([matcher failureMessageForShouldNot], failure, @"failure message should match");
}

@end

#endif // #if KW_TESTS_ENABLED
