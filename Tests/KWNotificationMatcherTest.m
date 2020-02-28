//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWNotificatoinMatcherTest : XCTestCase

@end

@implementation KWNotificatoinMatcherTest

- (void)testItShouldHaveTheRightMatcherStrings {
    NSArray *matcherStrings = [KWNotificationMatcher matcherStrings];
    NSArray *expectedStrings = @[@"bePosted",
                                 @"bePostedWithObject:",
                                 @"bePostedWithUserInfo:",
                                 @"bePostedWithObject:andUserInfo:",
                                 @"bePostedWithObject:userInfo:",
                                 @"bePostedEvaluatingBlock:"];
    XCTAssertEqualObjects([matcherStrings sortedArrayUsingSelector:@selector(compare:)],
                         [expectedStrings sortedArrayUsingSelector:@selector(compare:)],
                         @"expected specific matcher strings");
}

- (void)testEachMatcherStringIsANameOfAMatchingMethod {
    NSArray *matcherStrings = [KWNotificationMatcher matcherStrings];
    for (NSString *string in matcherStrings) {
        XCTAssertTrue([KWNotificationMatcher instancesRespondToSelector:NSSelectorFromString(string)],
                      @"expect to find an instance method: %@", string);
    }
}

- (void)testCanMatchSubjectWithStringAndNotObject {
    XCTAssertTrue([KWNotificationMatcher canMatchSubject:NSPortDidBecomeInvalidNotification], @"should be able to match notification name");
    XCTAssertFalse([KWNotificationMatcher canMatchSubject:[NSObject new]], @"should not be able to match NSObject as a subject");
}

- (void)testShouldBeEvaluatedAtEndOfExample {
    KWNotificationMatcher *matcher = [KWNotificationMatcher matcherWithSubject:NSPortDidBecomeInvalidNotification];
    XCTAssertTrue([matcher shouldBeEvaluatedAtEndOfExample], @"should evaluate at the end of example to catch async notifications");
}

- (void)testItShouldMatchPostedNotificationWithAnyObject {
    id object = [NSObject new];
    id subject = @"MyNotification";
    KWNotificationMatcher *matcher = [KWNotificationMatcher matcherWithSubject:subject];
    [matcher bePosted];
    [[NSNotificationCenter defaultCenter] postNotificationName:subject object:object];
    XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldMatchPostedNotificationWithMatchingObject {
    id object = [NSObject new];
    id subject = @"MyNotification";
    KWNotificationMatcher *matcher = [KWNotificationMatcher matcherWithSubject:subject];
    [matcher bePostedWithObject:object];
    [[NSNotificationCenter defaultCenter] postNotificationName:subject object:object];
    XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldMatchPostedNotificationWithMatchingUserInfo {
    id object = [NSObject new];
    id subject = @"MyNotification";
    KWNotificationMatcher *matcher = [KWNotificationMatcher matcherWithSubject:subject];
    [matcher bePostedWithUserInfo:@{@"a":@"b", @1:@2}];
    [[NSNotificationCenter defaultCenter] postNotificationName:subject object:object userInfo:@{@"a":@"b", @1:@2}];
    XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldMatchPostedNotificationWithMatchingObjectAndUserInfo {
    id object = [NSObject new];
    id subject = @"MyNotification";
    KWNotificationMatcher *matcher = [KWNotificationMatcher matcherWithSubject:subject];
    [matcher bePostedWithObject:object userInfo:@{@"a":@"b", @1:@2}];
    [[NSNotificationCenter defaultCenter] postNotificationName:subject object:object userInfo:@{@"a":@"b", @1:@2}];
    XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldMatchPostedNotificationEvaluatingBlock {
    id object = [NSObject new];
    id subject = @"MyNotification";
    KWNotificationMatcher *matcher = [KWNotificationMatcher matcherWithSubject:subject];
    [matcher bePostedEvaluatingBlock:^(NSNotification *note) {
        XCTAssertEqual(subject, [note name], @"expected notification name");
        XCTAssertEqual(object, [note object], @"expected notification object");
        XCTAssertNotNil([note userInfo][@"PATH"], @"expected notification user info to include environment PATH");
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:subject object:object userInfo:[[NSProcessInfo processInfo] environment]];
    XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchWhenNothingHaveBeenPosted {
    id subject = @"MyNotification";
    KWNotificationMatcher *matcher = [KWNotificationMatcher matcherWithSubject:subject];
    [matcher bePosted];
    XCTAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldHaveHumanReadableDescription {
    id matcher = [KWNotificationMatcher matcherWithSubject:NSPortDidBecomeInvalidNotification];
    [matcher bePosted];
    XCTAssertEqualObjects(@"NSPortDidBecomeInvalidNotification be posted", [matcher description], @"description should match");
}

- (void)testItShouldHaveInformativeFailureMessageForShould {
    id matcher = [KWNotificationMatcher matcherWithSubject:NSPortDidBecomeInvalidNotification];
    [matcher bePosted];
    XCTAssertEqualObjects([matcher failureMessageForShould],
                          @"expect to receive \"NSPortDidBecomeInvalidNotification\" notification",
                          @"failure message should match");
}

- (void)testItShouldHaveInformativeFailureMessageForShouldWithObject {
    id matcher = [KWNotificationMatcher matcherWithSubject:NSPortDidBecomeInvalidNotification];
    [matcher bePostedWithObject:@"sender"];
    XCTAssertEqualObjects([matcher failureMessageForShould],
                          @"expect to receive \"NSPortDidBecomeInvalidNotification\" notification with object: sender",
                          @"failure message should match");
}

- (void)testItShouldHaveInformativeFailureMessageForShouldWithUserInfo {
    id matcher = [KWNotificationMatcher matcherWithSubject:NSPortDidBecomeInvalidNotification];
    [matcher bePostedWithUserInfo:@{@"message":@"text"}];
    XCTAssertEqualObjects([matcher failureMessageForShould],
                          @"expect to receive \"NSPortDidBecomeInvalidNotification\" notification with user info: {\n    message = text;\n}",
                          @"failure message should match");
}

- (void)testItShouldHaveInformativeFailureMessageForShouldWithObjectAndUserInfo {
    id matcher = [KWNotificationMatcher matcherWithSubject:NSPortDidBecomeInvalidNotification];
    [matcher bePostedWithObject:@"sender" userInfo:@{@"message":@"text"}];
    XCTAssertEqualObjects([matcher failureMessageForShould], @"expect to receive \"NSPortDidBecomeInvalidNotification\" "
                         "notification with object: sender and user info: {\n    message = text;\n}",
                          @"failure message should match");
}

- (void)testItShouldHaveInformativeFailureMessageForShouldNot {
    id matcher = [KWNotificationMatcher matcherWithSubject:@"MyNotification"];
    [matcher bePosted];
    NSNotification *notification = [[NSNotification alloc] initWithName:@"MyNotification" object:self userInfo:@{@"when":@"today"}];
    NSString *description = [notification description];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    NSString *expectedDescription = [NSString stringWithFormat:@"expect not to receive \"MyNotification\" notification, but received: %@", description];
    XCTAssertEqualObjects([matcher failureMessageForShouldNot], expectedDescription, @"failure message should match");
}

@end

#endif // #if KW_TESTS_ENABLED
