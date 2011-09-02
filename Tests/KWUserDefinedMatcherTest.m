//
//  KWUserDefinedMatcherTest.m
//  Kiwi
//
//  Created by Luke Redpath on 16/06/2011.
//  Copyright 2011 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWUserDefinedMatcherTest : SenTestCase
@end

@implementation KWUserDefinedMatcherTest

- (void)testShouldPassTheSubjectInAsTheFirstBlockArgument
{
    __block id blockSubject = nil;

    KWUserDefinedMatcher *matcher = [KWUserDefinedMatcher matcherWithSubject:@"subject" block:^(id subject) {
        blockSubject = subject;
        return YES;
    }];
    [matcher evaluate];

    STAssertEquals(@"subject", blockSubject, @"expected subject to be passed into matcher block");
}

- (void)testShouldPassWhenBlockSpecificationReturnsYes
{
    KWUserDefinedMatcher *matcher = [KWUserDefinedMatcher matcherWithSubject:nil block:^(id subject) {
        return YES;
    }];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testShouldFailWhenBlockSpecificationReturnsNo
{
    KWUserDefinedMatcher *matcher = [KWUserDefinedMatcher matcherWithSubject:nil block:^(id subject) {
        return NO;
    }];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testShouldYieldMessageArgumentToTheBlock
{
    KWUserDefinedMatcher *matcher = [KWUserDefinedMatcher matcherWithSubject:@"string" block:^(id subject, id object) {
        return [(NSString *)object isEqualToString:subject];
    }];
    matcher.selector = NSSelectorFromString(@"matchTheString:");
    [matcher performSelector:matcher.selector withObject:@"string"];

    STAssertTrue([matcher evaluate], @"expected subject to match yielded argument");
}

@end

#pragma mark -

@interface KWUserDefinedMatcherBuilderTest : SenTestCase
@end

@implementation KWUserDefinedMatcherBuilderTest

- (void)testShouldDefineTheBlockToEvaluate
{
    KWUserDefinedMatcherBuilder *builder = [KWUserDefinedMatcherBuilder builder];

    [builder match:^(id subject) {
        return [subject isEqual:@"foo"];
    }];

    KWUserDefinedMatcher *matcher = [builder buildMatcherWithSubject:@"foo"];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testShouldSetTheSelectorForTheMatcher
{
    KWUserDefinedMatcherBuilder *builder = [KWUserDefinedMatcherBuilder builderForSelector:NSSelectorFromString(@"dummySelector")];
    KWUserDefinedMatcher *matcher = [builder buildMatcherWithSubject:@"foo"];
    STAssertEquals(NSSelectorFromString(@"dummySelector"), matcher.selector, @"should set selector");

}

- (void)testCanSetTheFailureMessageForShould
{
    KWUserDefinedMatcherBuilder *builder = [KWUserDefinedMatcherBuilder builder];

    [builder failureMessageForShould:^(id subject) {
        return [NSString stringWithFormat:@"failure message containing subject %@", subject];
    }];

    KWUserDefinedMatcher *matcher = [builder buildMatcherWithSubject:@"foo"];
    STAssertEqualObjects(@"failure message containing subject foo", [matcher failureMessageForShould], @"should set failure message for should");
}

- (void)testCanSetTheFailureMessageForShouldNot
{
    KWUserDefinedMatcherBuilder *builder = [KWUserDefinedMatcherBuilder builder];

    [builder failureMessageForShouldNot:^(id subject) {
        return [NSString stringWithFormat:@"failure message containing subject %@", subject];
    }];

    KWUserDefinedMatcher *matcher = [builder buildMatcherWithSubject:@"foo"];
    STAssertEqualObjects(@"failure message containing subject foo", [matcher failureMessageForShouldNot], @"should set failure message for should");
}

@end

#endif

