//
//  Galaxy.m
//  Kiwi
//
//  Created by Nathan Heagy on 12-03-22.
//  Copyright (c) 2012 Allen Ding. All rights reserved.
//

#import "Galaxy.h"

@implementation Galaxy

+ (id)sharedGalaxy
{
	static Galaxy *instance;
	
	static dispatch_once_t predicate;   
	dispatch_once(&predicate, ^{
		instance = [[Galaxy alloc] init];
	});
	
	return instance;
}

- (void)notifyPlanet:(int)planet {
    NSLog(@"Planet %d was notified", planet);
}
- (void)notifyEarth {
    [self notifyPlanet:1];
}

- (NSString *)name
{
    return @"Milky Way";
}
@end
