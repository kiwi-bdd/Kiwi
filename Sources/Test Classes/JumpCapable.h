//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "OrbitCapable.h"

@protocol JumpCapable<OrbitCapable>

#pragma mark -
#pragma mark Jumping

- (void)computeParsecs;
- (void)engageHyperdrive;
- (NSUInteger)hyperdriveFuelLevel;

@end
