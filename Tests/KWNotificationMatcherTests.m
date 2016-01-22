#import <Kiwi/Kiwi.h>
#import "KiwiTestConfiguration.h"

#if KW_TESTS_ENABLED

static NSString *const KWTestNotification = @"KWTestNotification";

@interface KWNotificationMatcherTests : XCTestCase
@end

@implementation KWNotificationMatcherTests

- (void)testItShouldHaveTheRightMatherStrings {
    NSArray *matcherStrings = [KWNotificationMatcher matcherStrings];
    NSArray *expectedStrings = @[@"bePosted",
                                 @"bePostedWithObject:",
                                 @"bePostedWithUserInfo:",
                                 @"bePostedWithObject:andUserInfo:",
                                 @"bePostedEvaluatingBlock:"];

    XCTAssertEqualObjects(expectedStrings, matcherStrings);
}

- (void)testItShouldMatchAPostedNotification {
    KWNotificationMatcher *matcher = [[KWNotificationMatcher alloc] initWithSubject:KWTestNotification];
    [matcher bePosted];
    [[NSNotificationCenter defaultCenter] postNotificationName:KWTestNotification object:nil];
    XCTAssertTrue([matcher evaluate]);
}

- (void)testItShouldMatchNotMatchWhenNoNotificationIsPosted {
    KWNotificationMatcher *matcher = [[KWNotificationMatcher alloc] initWithSubject:KWTestNotification];
    [matcher bePosted];
    XCTAssertFalse([matcher evaluate]);
}

- (void)testItShouldMatchNotificationsForASpecificObject {
    KWNotificationMatcher *matcher = [[KWNotificationMatcher alloc] initWithSubject:KWTestNotification];
    NSObject *object = [NSObject new];
    [matcher bePostedWithObject:object];
    [[NSNotificationCenter defaultCenter] postNotificationName:KWTestNotification object:object];
    XCTAssertTrue([matcher evaluate]);
}

- (void)testItShouldMatchNotificationsForASpecificObject {
    KWNotificationMatcher *matcher = [[KWNotificationMatcher alloc] initWithSubject:KWTestNotification];
    NSObject *object = [NSObject new];
    [matcher bePostedWithObject:object];
    [[NSNotificationCenter defaultCenter] postNotificationName:KWTestNotification object:object];
    XCTAssertTrue([matcher evaluate]);
}

//- (void)testItShouldBeDeallocated {
//    __weak KWNotificationMatcher *weakMatcher;
//    {
//        KWNotificationMatcher *matcher = [[KWNotificationMatcher alloc] initWithSubject:KWTestNotification];
//        weakMatcher = matcher;
//        [matcher bePosted];
//    }
//    XCTAssertNil(weakMatcher);
//}

@end

#endif
