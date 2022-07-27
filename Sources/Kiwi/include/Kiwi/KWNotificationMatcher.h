//
//  KWNotificationMatcher.h
//
//  Created by Paul Zabelin on 7/12/12.
//  Copyright (c) 2012 Blazing Cloud, Inc. All rights reserved.
//

#import "KWMatcher.h"

typedef void (^PostedNotificationBlock)(NSNotification* note);

@interface KWNotificationMatcher : KWMatcher

- (void)bePosted;
- (void)bePostedWithObject:(id)object;
- (void)bePostedWithUserInfo:(NSDictionary *)userInfo;
- (void)bePostedWithObject:(id)object andUserInfo:(NSDictionary *)userInfo DEPRECATED_MSG_ATTRIBUTE("Use -bePostedWithObject:userInfo: method instead.");
- (void)bePostedWithObject:(id)object userInfo:(NSDictionary *)userInfo;
- (void)bePostedEvaluatingBlock:(PostedNotificationBlock)block;

#pragma mark - KWMatching
@property (nonatomic, assign) BOOL willEvaluateMultipleTimes;
@end
