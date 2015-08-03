#import <Kiwi/Kiwi.h>

SPEC_BEGIN(KWAsyncFunctionalTests)

describe(@"shouldEventually", ^{
    it(@"re-evaluates the expectation asynchronously", ^{
        __block NSUInteger count = 0;
        __block id subject = nil;

        KWFutureObject *future = [KWFutureObject futureObjectWithBlock:^{
            count++;
            return subject;
        }];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [NSThread sleepForTimeInterval:0.3];
            subject = [NSObject new];
        });

        [[future shouldEventually] beNonNil];
        [[theValue(count) should] beGreaterThan:theValue(1)];
    });

    pending(@"should not allow regular subjects to be attached to async verifiers", ^{
        __block BOOL called = NO;

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [NSThread sleepForTimeInterval:0.1];
            called = YES;
        });

        // FIXME: This shouldn't even compile
        [[theValue(called) shouldEventually] beYes];
    });
});

SPEC_END
