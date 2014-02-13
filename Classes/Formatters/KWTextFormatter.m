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

#pragma mark - Internal Methods

- (void)reportResultForExample:(KWExample *)example label:(NSString *)label {
    NSLog(@"+ '%@' [%@]", [example descriptionWithContext], label);
}

@end
