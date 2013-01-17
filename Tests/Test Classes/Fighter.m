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
        callsign = [aCallsign copy];
    }

    return self;
}

+ (id)fighter {
    return [self fighterWithCallsign:nil];
}

+ (id)fighterWithCallsign:(NSString *)aCallsign {
    return [[[self alloc] initWithCallsign:aCallsign] autorelease];
}

- (void)dealloc {
    [callsign release];
    [super dealloc];
}

#pragma mark -
#pragma mark Properties

@synthesize callsign;
@synthesize engine;

+ (NSString *)classification {
    return @"Starfighter";
}

@end
