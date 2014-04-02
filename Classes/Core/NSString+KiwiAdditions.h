//
//  NSString+KiwiAdditions.h
//  Kiwi
//
//  Created by Cristian Kocza on 02/04/14.
//  Copyright (c) 2014 Allen Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (KiwiAdditions)

//returns true if the selector name represented by the string belongs to the given family
- (BOOL)belongsToMethodFamily:(NSString*)family;

@end
