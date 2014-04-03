#import "MABaseFuture.h"

#import <objc/runtime.h>


@implementation MABaseFuture

- (id)init
{
    _lock = [[NSCondition alloc] init];
    return self;
}

- (void)dealloc
{
    [_value release];
    [_lock release];
    
    [super dealloc];
}

- (void)setFutureValue: (id)value
{
    [_lock lock];
    [self setFutureValueUnlocked: value];
    [_lock unlock];
}

- (id)futureValue
{
    // skip the usual retain/autorelease dance here
    // because the setter is never called more than
    // once, thus value lifetime is same as future
    // lifetime
    [_lock lock];
    id value = _value;
    [_lock unlock];
    return value;
}

- (void)setFutureValueUnlocked: (id)value
{
    [value retain];
    [_value release];
    _value = value;
    _resolved = YES;
    [_lock broadcast];
}

- (BOOL)futureHasResolved
{
    return _resolved;
}

- (id)waitForFutureResolution
{
    [_lock lock];
    while(!_resolved)
        [_lock wait];
    [_lock unlock];
    return _value;
}

- (id)resolveFuture
{
    NSAssert1(NO, @"-[MABaseFuture resolveFuture] called, this should never happen! Did you forget to implement -[%@ resolveFuture]?", object_getClass(self));
    __builtin_unreachable();
}

- (Class)class
{
    Class c = [[self resolveFuture] class];
    if([NSStringFromClass(c) hasPrefix: @"NSCF"])
        return [c superclass];
    else
        return c;
}

@end
