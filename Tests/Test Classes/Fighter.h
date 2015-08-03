//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpaceShip.h"

@class Engine;

@interface Fighter : SpaceShip

#pragma mark -
#pragma mark Initializing

- (instancetype)initWithCallsign:(NSString *)aCallsign;

+ (instancetype)fighterWithCallsign:(NSString *)aCallsign;

#pragma mark -
#pragma mark Properties

@property (nonatomic, copy, readonly) NSString *callsign;
@property (nonatomic, readonly) Engine *engine;

+ (NSString *)classification;

@end
