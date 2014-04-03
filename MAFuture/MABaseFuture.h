#import <Foundation/Foundation.h>

#import "MAProxy.h"


@interface MABaseFuture : MAProxy
{
    id _value;
    NSCondition *_lock;
    BOOL _resolved;
}

- (id)init;

// access value while holding the lock
// don't call the setter more than once
- (void)setFutureValue: (id)value;
- (id)futureValue;

// if you lock manually, you can use this
- (void)setFutureValueUnlocked: (id)value;

// checks to see if setFutureValue: has been called yet
// lock the lock first for best results
- (BOOL)futureHasResolved;

// if setFutureValue: has not been called yet, blocks until it has
// returns _value
- (id)waitForFutureResolution;

// subclasses must implement! don't call super!
// returns the future value, blocks for it to resolve if needed
- (id)resolveFuture;

@end
