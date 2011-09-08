//
//  KWExampleGroupDelegate.h
//  Kiwi
//
//  Created by Luke Redpath on 08/09/2011.
//  Copyright 2011 Allen Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KWExampleGroup;
@class KWFailure;

@protocol KWExampleGroupDelegate <NSObject>

- (void)exampleGroup:(KWExampleGroup *)exampleGroup didFailWithFailure:(KWFailure *)failure;

@end
