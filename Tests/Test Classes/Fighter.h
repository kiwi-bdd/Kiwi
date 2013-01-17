//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SpaceShip.h"

@class Engine;

@interface Fighter : SpaceShip {
@private
    NSString *callsign;
    Engine *engine;
}

#pragma mark -
#pragma mark Initializing

- (id)initWithCallsign:(NSString *)aCallsign;

+ (id)fighter;
+ (id)fighterWithCallsign:(NSString *)aCallsign;

#pragma mark -
#pragma mark Properties

@property (nonatomic, readonly) NSString *callsign;
@property (nonatomic, readonly) Engine *engine;

+ (NSString *)classification;

@end
