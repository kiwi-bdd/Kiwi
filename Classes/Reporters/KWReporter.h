//
//  KWReporter.h
//  Kiwi
//
//  Created by Brian Ivan Gesiak on 2/12/14.
//  Copyright (c) 2014 Allen Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KWSpec;
@class KWExample;
@protocol KWListener;

@interface KWReporter : NSObject

+ (instancetype)sharedReporter;

- (void)registerSpecClass:(Class)specClass;
- (void)registerListener:(id<KWListener>)listener;

#pragma mark - Notifying Listeners

- (void)specStarted:(KWSpec *)spec;
- (void)message:(NSString *)message;
- (void)exampleStarted:(KWExample *)example;
- (void)examplePending:(KWExample *)example;
- (void)exampleFinished:(KWExample *)example;
- (void)examplePassed:(KWExample *)example;
- (void)exampleFailed:(KWExample *)example;
- (void)specFinished:(KWSpec *)spec;

@end
