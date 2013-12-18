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
    NSArray *expectedStrings = @[@"bePosted:"];
    STAssertEqualObjects([matcherStrings sortedArrayUsingSelector:@selector(compare:)],
                         [expectedStrings sortedArrayUsingSelector:@selector(compare:)],
                         @"expected specific matcher strings");
}

- (void)testItShouldMatchPostedNotification {
    id object = [[NSObject alloc] init];
    id subject = @"MyNotification";
    id matcher = [KWNotificationMatcher matcherWithSubject:subject];
    [matcher bePosted:^(NSNotification *note) {
        STAssertEquals(subject, [note name], @"expected notification name");
        STAssertEquals(object, [note object], @"expected notification object");
    }];
    [[NSNotificationCenter defaultCenter] postNotificationName:subject object:object];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchWhenNothingHaveBeenPosted {
    id subject = @"MyNotification";
    id matcher = [KWNotificationMatcher matcherWithSubject:subject];
    [matcher bePosted:^(NSNotification *note) {
        STFail(@"received unexpected notification: %@", note);
    }];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldHaveHumanReadableDescription
{
  id matcher = [KWNotificationMatcher matcherWithSubject:NSPortDidBecomeInvalidNotification];
  [matcher bePosted:NULL];
  STAssertEqualObjects(@"NSPortDidBecomeInvalidNotification be posted", [matcher description], @"description should match");
}

- (void)testItShouldHaveInformativeFailureMessageForShould
{
    id matcher = [KWNotificationMatcher matcherWithSubject:NSPortDidBecomeInvalidNotification];
    [matcher bePosted:NULL];
    STAssertEqualObjects([matcher failureMessageForShould], @"expect to receive \"NSPortDidBecomeInvalidNotification\" notification", @"failure message should match");
}

- (void)testItShouldHaveInformativeFailureMessageForShouldNot
{
    id matcher = [KWNotificationMatcher matcherWithSubject:@"MyNotification"];
    [matcher bePosted:NULL];
    NSNotification *notification = [[NSNotification alloc] initWithName:@"MyNotification" object:self userInfo:@{@"when":@"today"}];
    NSString *description = [notification description];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    NSString *expectedDescription = [NSString stringWithFormat:@"expect not to receive \"MyNotification\" notification, but received: %@", description];
    STAssertEqualObjects([matcher failureMessageForShouldNot], expectedDescription, @"failure message should match");
}


@end

#endif // #if KW_TESTS_ENABLED
