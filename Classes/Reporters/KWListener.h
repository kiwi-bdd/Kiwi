//
// Licensed under the terms in License.txt
//
// Copyright 2014 Allen Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KWExampleNotification.h"
#import "KWMessageNotification.h"
#import "KWSummaryNotification.h"

@protocol KWListener <NSObject>
@optional
- (void)start;
- (void)message:(KWMessageNotification *)notification;
- (void)exampleStarted:(KWExampleNotification *)notification;
- (void)examplePassed:(KWExampleNotification *)notification;
- (void)examplePending:(KWExampleNotification *)notification;
- (void)exampleFinished:(KWExampleNotification *)notification;
- (void)exampleFailed:(KWExampleNotification *)notification;
- (void)stop;
- (void)startDump;
- (void)dumpPending;
- (void)dumpFailures;
- (void)dumpSummary:(KWSummaryNotification *)notification;
- (void)close;
@end
