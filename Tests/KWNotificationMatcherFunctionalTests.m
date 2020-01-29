#import <Kiwi/Kiwi.h>
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

SPEC_BEGIN(KWNotificationMatcherFunctionalTests)

describe(@"KWNotificationMatcher", ^{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];

    context(@"bePosted", ^{
        it(@"should match posted notification", ^{
            [[@"My Notification" should] bePosted];
            [center postNotificationName:@"My Notification" object:nil];
        });
    });

    context(@"bePostedWithObject", ^{
        it(@"should match object", ^{
            NSObject *object = [NSObject new];
            [[@"My Notification" should] bePostedWithObject:object];
            [[@"My Notification" shouldNot] bePostedWithObject:@"not matching object"];
            [center postNotificationName:@"My Notification" object:object];
        });
    });

    context(@"bePostedWithUserInfo", ^{
        it(@"should match user info", ^{
            [[@"My Notification" should] bePostedWithUserInfo:@{@"some key":@"some value"}];
            [[@"My Notification" shouldNot] bePostedWithUserInfo:@{@"some key":@"not matching value"}];
            [center postNotificationName:@"My Notification" object:nil userInfo:@{@"some key":@"some value"}];
        });
    });

    context(@"bePostedWithObject:userInfo:", ^{
        it(@"should match both object and user info", ^{
            NSObject *object = [NSObject new];
            [[@"My Notification" should] bePostedWithObject:object userInfo:@{@"some key":@"some value"}];
            [[@"My Notification" shouldNot] bePostedWithObject:object userInfo:@{@"some key":@"not matching value"}];
            [[@"My Notification" shouldNot] bePostedWithObject:[NSObject new] userInfo:@{@"some key":@"some value"}];
            [center postNotificationName:@"My Notification" object:object userInfo:@{@"some key":@"some value"}];

        });
    });

    context(@"bePostedEvaluatingBlock", ^{
        it(@"should match and evaluate block", ^{
            __block BOOL blockWasEvaluated = NO;
            [[@"My Notification" should] bePostedEvaluatingBlock:^(NSNotification *note) {
                [[note shouldNot] beNil];
                [[note.name should] equal:@"My Notification"];
                blockWasEvaluated = TRUE;
            }];
            [center postNotificationName:@"My Notification" object:nil];
            [[theValue(blockWasEvaluated) should] beTrue];
        });
    });

    context(@"asynchronous notification", ^{
        void (^postDelayedNotification)(void) = ^{
            [center performSelector:@selector(postNotificationName:object:) withObject:@"My Notification" afterDelay:0];
        };

        it(@"should not match syncronous expectation", ^{
            [[@"My Notification" shouldNot] bePosted];
            postDelayedNotification();
        });

        it(@"should match eventually", ^{
            [[@"My Notification" shouldEventually] bePosted];
            postDelayedNotification();
        });
    });
});

SPEC_END
