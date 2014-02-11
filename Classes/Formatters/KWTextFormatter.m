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

- (void)examplePassed:(KWEventNotification *)notification {
    [self reportResultForExample:notification.example
                           label:@"PASSED"];
}

- (void)examplePending:(KWEventNotification *)notification {
    [self reportResultForExample:notification.example
                           label:@"PENDING"];
}

- (void)exampleFailed:(KWEventNotification *)notification {
    [self reportResultForExample:notification.example
                           label:@"FAILED"];
}

#pragma mark - Internal Methods

- (void)reportResultForExample:(KWExample *)example label:(NSString *)label {
    NSLog(@"+ '%@' [%@]", [example descriptionWithContext], label);
}

@end
