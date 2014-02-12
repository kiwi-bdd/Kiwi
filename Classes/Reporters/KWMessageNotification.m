//
//  KWMessageNotification.m
//  Kiwi
//
//  Created by Brian Ivan Gesiak on 2/12/14.
//  Copyright (c) 2014 Allen Ding. All rights reserved.
//

#import "KWMessageNotification.h"

@implementation KWMessageNotification

#pragma mark - Initializing

- (id)initWithMessage:(NSString *)message {
    self = [super init];
    if (self) {
        _message = message;
    }
    return self;
}

@end
