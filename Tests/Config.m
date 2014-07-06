#import <XCTest/XCTest.h>
#import "Kiwi.h"

CONFIG_START

beforeAllSpecs(^{
    static NSUInteger called = 0;
    NSLog(@"beforeAllSpecs");
    NSAssert(++called == 1, @"expected beforeAllSpecs to be called only once");
});

afterAllSpecs(^{
    static NSUInteger called = 0;
    NSLog(@"afterAllSpecs");
    NSAssert(++called == 1, @"expected afterAllSpecs to be called only once");
});

CONFIG_END
