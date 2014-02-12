//
//  KWTextFormatter.m
//  Kiwi
//
//  Created by Brian Ivan Gesiak on 2/12/14.
//  Copyright (c) 2014 Allen Ding. All rights reserved.
//

#import "KWTextFormatter.h"
#import "KWExample.h"

@implementation KWTextFormatter

#pragma mark - KWListener Protocol Methods

- (void)start {
    NSLog(@"%@:%@", [self class], NSStringFromSelector(_cmd));
}

- (void)message:(KWMessageNotification *)notification {
    NSLog(@"%@:%@", [self class], NSStringFromSelector(_cmd));
}

- (void)exampleStarted:(KWExampleNotification *)notification {
    NSLog(@"%@:%@", [self class], NSStringFromSelector(_cmd));
}

- (void)examplePassed:(KWExampleNotification *)notification {
    [self reportResultForExample:notification.example
                           label:@"PASSED"];
}

- (void)examplePending:(KWExampleNotification *)notification {
    [self reportResultForExample:notification.example
                           label:@"PENDING"];
}

- (void)exampleFailed:(KWExampleNotification *)notification {
    [self reportResultForExample:notification.example
                           label:@"FAILED"];
}

- (void)stop {
    NSLog(@"%@:%@", [self class], NSStringFromSelector(_cmd));
}

- (void)startDump {
    NSLog(@"%@:%@", [self class], NSStringFromSelector(_cmd));
}

- (void)dumpPending {
    NSLog(@"%@:%@", [self class], NSStringFromSelector(_cmd));
}

- (void)dumpFailures {
    NSLog(@"%@:%@", [self class], NSStringFromSelector(_cmd));
}

- (void)dumpSummary:(KWSummaryNotification *)notification {
    NSLog(@"%@:%@", [self class], NSStringFromSelector(_cmd));
}

- (void)close {
    NSLog(@"%@:%@", [self class], NSStringFromSelector(_cmd));
}

#pragma mark - Internal Methods

- (void)reportResultForExample:(KWExample *)example label:(NSString *)label {
    NSLog(@"+ '%@' [%@]", [example descriptionWithContext], label);
}

@end
