//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWNotificatoinMatcherTest : SenTestCase

@end

@implementation KWNotificatoinMatcherTest

- (void)testItShouldHaveTheRightMatcherStrings {
    NSArray *matcherStrings = [KWNotificationMatcher matcherStrings];
    NSArray *expectedStrings = @[@"bePosted", @"bePostedWithObject:", @"bePostedWithUserInfo:", @"bePostedWithObject:andUserInfo:", @"bePostedEvaluatingBlock:"];
    STAssertEqualObjects([matcherStrings sortedArrayUsingSelector:@selector(compare:)],
                         [expectedStrings sortedArrayUsingSelector:@selector(compare:)],
                         @"expected specific matcher strings");
}

- (void)testEachMatcherStringIsANameOfAMatchingMethod {
    NSArray *matcherStrings = [KWNotificationMatcher matcherStrings];
    for (NSString *string in matcherStrings) {
        STAssertTrue([KWNotificationMatcher instancesRespondToSelector:NSSelectorFromString(string)], @"expect to find an instance method: %@", string);
    }
}

- (void)testItShouldMatchPostedNotificationWithAnyObject {
    id object = [[[NSObject alloc] init] autorelease];
    id subject = @"MyNotification";
    id matcher = [KWNotificationMatcher matcherWithSubject:subject];
    [matcher bePosted];
    [[NSNotificationCenter defaultCenter] postNotificationName:subject object:object];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldMatchPostedNotificationWithMatchingObject {
    id object = [[[NSObject alloc] init] autorelease];
    id subject = @"MyNotification";
    id matcher = [KWNotificationMatcher matcherWithSubject:subject];
    [matcher bePostedWithObject:object];
    [[NSNotificationCenter defaultCenter] postNotificationName:subject object:object];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldMatchPostedNotificationWithMatchingUserInfo {
    id object = [[[NSObject alloc] init] autorelease];
    id subject = @"MyNotification";
    id matcher = [KWNotificationMatcher matcherWithSubject:subject];
    [matcher bePostedWithUserInfo:@{@"a":@"b", @1:@2}];
    [[NSNotificationCenter defaultCenter] postNotificationName:subject object:object userInfo:@{@"a":@"b", @1:@2}];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldMatchPostedNotificationWithMatchingObjectAndUserInfo {
    id object = [[[NSObject alloc] init] autorelease];
    id subject = @"MyNotification";
    id matcher = [KWNotificationMatcher matcherWithSubject:subject];
    [matcher bePostedWithObject:object andUserInfo:@{@"a":@"b", @1:@2}];
    [[NSNotificationCenter defaultCenter] postNotificationName:subject object:object userInfo:@{@"a":@"b", @1:@2}];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldMatchPostedNotificationEvaluatingBlock {
    id object = [[[NSObject alloc] init] autorelease];
    id subject = @"MyNotification";
    id matcher = [KWNotificationMatcher matcherWithSubject:subject];
    [matcher bePostedEvaluatingBlock:^(NSNotification *note) {
        STAssertEquals(subject, [note name], @"expected notification name");
        STAssertEquals(object, [note object], @"expected notification object");
        STAssertNotNil([note userInfo][@"PATH"], @"expected notification user info to include environment PATH");
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:subject object:object userInfo:[[NSProcessInfo processInfo] environment]];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchWhenNothingHaveBeenPosted {
    id subject = @"MyNotification";
    id matcher = [KWNotificationMatcher matcherWithSubject:subject];
    [matcher bePosted];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldHaveHumanReadableDescription {
    id matcher = [KWNotificationMatcher matcherWithSubject:NSPortDidBecomeInvalidNotification];
    [matcher bePosted];
    STAssertEqualObjects(@"NSPortDidBecomeInvalidNotification be posted", [matcher description], @"description should match");
}

- (void)testItShouldHaveInformativeFailureMessageForShould {
    id matcher = [KWNotificationMatcher matcherWithSubject:NSPortDidBecomeInvalidNotification];
    [matcher bePosted];
    STAssertEqualObjects([matcher failureMessageForShould], @"expect to receive \"NSPortDidBecomeInvalidNotification\" notification", @"failure message should match");
}

- (void)testItShouldHaveInformativeFailureMessageForShouldWithObject {
    id matcher = [KWNotificationMatcher matcherWithSubject:NSPortDidBecomeInvalidNotification];
    [matcher bePostedWithObject:@"sender"];
    STAssertEqualObjects([matcher failureMessageForShould], @"expect to receive \"NSPortDidBecomeInvalidNotification\" "
                         "notification with object: sender", @"failure message should match");
}

- (void)testItShouldHaveInformativeFailureMessageForShouldWithUserInfo {
    id matcher = [KWNotificationMatcher matcherWithSubject:NSPortDidBecomeInvalidNotification];
    [matcher bePostedWithUserInfo:@{@"message":@"text"}];
    STAssertEqualObjects([matcher failureMessageForShould], @"expect to receive \"NSPortDidBecomeInvalidNotification\" "
                         "notification with user info: {\n    message = text;\n}", @"failure message should match");
}

- (void)testItShouldHaveInformativeFailureMessageForShouldWithObjectAndUserInfo {
    id matcher = [KWNotificationMatcher matcherWithSubject:NSPortDidBecomeInvalidNotification];
    [matcher bePostedWithObject:@"sender" andUserInfo:@{@"message":@"text"}];
    STAssertEqualObjects([matcher failureMessageForShould], @"expect to receive \"NSPortDidBecomeInvalidNotification\" "
                         "notification with object: sender and user info: {\n    message = text;\n}", @"failure message should match");
}

- (void)testItShouldHaveInformativeFailureMessageForShouldNot {
    id matcher = [KWNotificationMatcher matcherWithSubject:@"MyNotification"];
    [matcher bePosted];
    NSNotification *notification = [[NSNotification alloc] initWithName:@"MyNotification" object:self userInfo:@{@"when":@"today"}];
    NSString *description = [notification description];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    NSString *expectedDescription = [NSString stringWithFormat:@"expect not to receive \"MyNotification\" notification, but received: %@", description];
    STAssertEqualObjects([matcher failureMessageForShouldNot], expectedDescription, @"failure message should match");
}

@end

#endif // #if KW_TESTS_ENABLED
