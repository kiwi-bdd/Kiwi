//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OrbitCapable<NSObject>

#pragma mark -
#pragma mark Orbiting

- (void)orbitPlanet:(id)aPlanet;
- (float)orbitPeriodForMass:(float)aMass;

@end
