//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWAny.h"

@implementation KWAny

#pragma mark -
#pragma mark Initializing

static KWAny *sharedAny = nil;

+ (id)any {
    if (sharedAny == nil) {
        sharedAny = [[super allocWithZone:nil] init];
    }

    return sharedAny;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [[self any] retain];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return NSUIntegerMax;
}

- (oneway void)release {
}

- (id)autorelease {
    return self;
}

@end
