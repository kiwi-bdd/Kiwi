//
//  Galaxy.h
//  Kiwi
//
//  Created by Nathan Heagy on 12-03-22.
//  Copyright (c) 2012 Allen Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Galaxy : NSObject

+ (id)sharedGalaxy;
- (void)notifyPlanet:(int)planet;
- (void)notifyEarth;
- (NSString *)name;

@end
