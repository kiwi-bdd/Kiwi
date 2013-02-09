//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWNull.h"

@implementation KWNull

#pragma mark -
#pragma mark Initializing

+ (id)null {
    static KWNull *sharedNull = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedNull = [[super allocWithZone:nil] init];
    });
    return sharedNull;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [self null];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

@end
