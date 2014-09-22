#import <Foundation/Foundation.h>
#import <libkern/OSAtomic.h>

#import "KW_MAProxy.h"


@implementation KW_MAProxy

+ (void)initialize
{
    // runtime requires an implementation
}

+ (id)alloc
{
    return NSAllocateObject(self, 0, NULL);
}

- (void)dealloc
{
    NSDeallocateObject(self);
}

- (void)finalize
{
}

- (BOOL)isProxy
{
    return YES;
}

- (id)retain
{
    OSAtomicIncrement32(&_refcountMinusOne);
    return self;
}

- (void)release
{
    if(OSAtomicDecrement32(&_refcountMinusOne) == -1)
        [self dealloc];
}

- (id)autorelease
{
    [NSAutoreleasePool addObject: self];
    return self;
}

- (NSUInteger)retainCount
{
    return _refcountMinusOne + 1;
}

@end
