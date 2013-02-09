//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWAny.h"

@implementation KWAny

#pragma mark -
#pragma mark Initializing


+ (id)any {
    static KWAny *sharedAny = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedAny = [[super allocWithZone:nil] init];
    });
    return sharedAny;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [self any];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

@end
