//
//  KWNotificationMatcher.h
//
//  Created by Paul Zabelin on 7/12/12.
//  Copyright (c) 2012 Blazing Cloud, Inc. All rights reserved.
//

#import "KWMatcher.h"

typedef void (^PostedNotificationBlock)(NSNotification* note);

@interface KWNotificationMatcher : KWMatcher

- (void)bePosted:(PostedNotificationBlock)block;

@end
