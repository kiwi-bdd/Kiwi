//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWNull.h"

@implementation KWNull

#pragma mark -
#pragma mark Initializing

static KWNull *sharedNull = nil;

+ (id)null {
    if (sharedNull == nil) {
        sharedNull = [[super allocWithZone:nil] init];
    }
    
    return sharedNull;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [[self null] retain];
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

- (void)release {
}

- (id)autorelease {
    return self;
}

@end
