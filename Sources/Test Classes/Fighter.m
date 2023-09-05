//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Fighter.h"
#import "Engine.h"

@implementation Fighter

#pragma mark -
#pragma mark Initializing

- (id)initWithCallsign:(NSString *)aCallsign {
    if ((self = [super init])) {
        _callsign = [aCallsign copy];
    }

    return self;
}

+ (id)fighterWithCallsign:(NSString *)aCallsign {
    return [[self alloc] initWithCallsign:aCallsign];
}

#pragma mark -
#pragma mark Properties

+ (NSString *)classification {
    return @"Starfighter";
}

@end
