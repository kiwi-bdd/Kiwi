//
// Licensed under the terms in License.txt
//
// Copyright 2014 Allen Ding. All rights reserved.
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
