//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JumpCapable.h"
#import "SpaceShip.h"

@class Engine;
@class Fighter;

@interface Cruiser : SpaceShip<JumpCapable> {
@private
    NSString *callsign;
    Engine *engine;
    NSArray *fighters;
}
#pragma mark -
#pragma mark Initializing

- (id)initWithCallsign:(NSString *)aCallsign;

+ (id)cruiser;
+ (id)cruiserWithCallsign:(NSString *)aCallsign;

#pragma mark -
#pragma mark Properties

@property (nonatomic, readonly) NSString *callsign;
@property (nonatomic, retain) Engine *engine;
@property (nonatomic, readonly) NSString *classification;

+ (NSString *)classification;
- (NSUInteger)crewComplement;

#pragma mark -
#pragma mark Managing Fighters

@property (nonatomic, readwrite, retain) NSArray *fighters;

- (Fighter *)fighterWithCallsign:(NSString *)aCallsign;
- (NSArray *)fightersInSquadron:(NSString *)aSquadron;

#pragma mark -
#pragma mark Managing Systems

- (BOOL)raiseShields;
- (float)energyLevelInWarpCore:(NSUInteger)anIndex;

#pragma mark -
#pragma mark Getting Navigation Information

// starHash => key/2 + key/4 + key/8 + ... 1
- (NSUInteger)computeStarHashForKey:(NSUInteger)aKey;

#pragma mark -
#pragma mark Orbiting

- (void)orbitPlanet:(id)aPlanet;
- (float)orbitPeriodForMass:(float)aMass;

#pragma mark -
#pragma mark Jumping

- (void)computeParsecs;
- (void)engageHyperdrive;
- (NSUInteger)hyperdriveFuelLevel;

#pragma mark -
#pragma mark Raising

- (void)raise;
- (void)raiseWithName:(NSString *)aName description:(NSString *)aDescription;

@end
