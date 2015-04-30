//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Cruiser.h"
#import "Engine.h"
#import "Fighter.h"

@implementation Cruiser

#pragma mark -
#pragma mark Initializing

- (instancetype)initWithCallsign:(NSString *)aCallsign {
    self = [super init];
    if (self) {
        _callsign = [aCallsign copy];
    }
    return self;
}

+ (instancetype)cruiserWithCallsign:(NSString *)aCallsign {
    return [[self alloc] initWithCallsign:aCallsign];
}

- (NSUInteger)hash {
    return self.crewComplement + [super hash];
}

#pragma mark -
#pragma mark Properties

+ (NSString *)classification {
    return @"Capital Ship";
}

- (NSString *)classification {
  return [[self class] classification];
}

- (NSUInteger)crewComplement {
    return 1010;
}

#pragma mark -
#pragma mark Managing Fighters

- (Fighter *)fighterWithCallsign:(NSString *)aCallsign {
    for (Fighter *fighter in self.fighters) {
        if ([fighter.callsign isEqualToString:aCallsign])
            return fighter;
    }

    return nil;
}

- (Fighter *)fighterWithCallsignUTF8CString:(const char *)aCallsign {
	return [self fighterWithCallsign:[NSString stringWithCString:aCallsign encoding:NSUTF8StringEncoding]];
}

- (NSArray *)fightersInSquadron:(NSString *)aSquadron {
    NSMutableArray *fightersInSquadron = [NSMutableArray new];

    for (Fighter *fighter in self.fighters) {
        if ([fighter.callsign hasPrefix:aSquadron])
            [fightersInSquadron addObject:fighter];
    }

    return fightersInSquadron;
}

- (void)loadFighter:(Fighter *)fighter
{
    NSMutableArray *newFighters = [self.fighters mutableCopy];
    [newFighters addObject:fighter];
    self.fighters = newFighters;
}

#pragma mark -
#pragma mark Managing Systems

- (BOOL)raiseShields {
    return [super raiseShields];
}

- (float)energyLevelInWarpCore:(NSUInteger)anIndex {
    return 42.0f * (float)anIndex;
}

#pragma mark -
#pragma mark Getting Navigation Information

- (NSUInteger)computeStarHashForKey:(NSUInteger)aKey {
    if (aKey == 0)
        return 0;

    return aKey + [self computeStarHashForKey:aKey/2];
}

#pragma mark -
#pragma mark Orbiting

- (void)orbitPlanet:(id)aPlanet {
    NSLog(@"orbiting planet ...");
}

- (float)orbitPeriodForMass:(float)aMass {
    return aMass * 9.8f;
}

#pragma mark -
#pragma mark Jumping

- (void)computeParsecs {
    NSLog(@"computing parsecs ...");
}

- (void)engageHyperdrive {
    NSLog(@"engaging hyperdrive ...");
}

- (NSUInteger)hyperdriveFuelLevel {
    return 77;
}

#pragma mark -
#pragma mark Raising

- (void)raise {
    [NSException raise:@"CruiserException" format:@"-[Cruiser raise]"];
}

- (void)raiseWithName:(NSString *)aName description:(NSString *)aDescription {
    [NSException raise:aName format:@"%@", aDescription];
}

@end
