//
//  KWListener.h
//  Kiwi
//
//  Created by Brian Ivan Gesiak on 2/12/14.
//  Copyright (c) 2014 Allen Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KWEventNotification.h"

@protocol KWListener <NSObject>
@optional
- (void)exampleStarted:(KWEventNotification *)notification;
- (void)examplePending:(KWEventNotification *)notification;
- (void)exampleFinished:(KWEventNotification *)notification;
- (void)examplePassed:(KWEventNotification *)notification;
- (void)exampleFailed:(KWEventNotification *)notification;
@end
