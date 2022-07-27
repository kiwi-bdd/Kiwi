//
//  KWNotificationMatcher.m
//
//  Created by Paul Zabelin on 7/12/12.
//  Copyright (c) 2012 Blazing Cloud, Inc. All rights reserved.
//

#import "KWNotificationMatcher.h"
#import "KWFormatter.h"

@interface KWNotificationMatcher ()
@property (nonatomic, strong) NSNotification *notification;
@property (nonatomic, strong) id observer;
@property (nonatomic, copy) PostedNotificationBlock evaluationBlock;
@property (nonatomic, strong) id expectedObject;
@property (nonatomic, strong) NSDictionary *expectedUserInfo;
@property (nonatomic, assign) BOOL didReceiveNotification;
@end

@implementation KWNotificationMatcher

+ (NSArray *)matcherStrings {
    return @[@"bePosted",
             @"bePostedWithObject:",
             @"bePostedWithUserInfo:",
             @"bePostedWithObject:andUserInfo:",
             @"bePostedWithObject:userInfo:",
             @"bePostedEvaluatingBlock:"];
}

- (void)addObserver {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    self.observer = [center addObserverForName:self.subject
                                        object:self.expectedObject
                                         queue:nil
                                    usingBlock:^(NSNotification *note) {
                                        self.notification = note;
                                        self.didReceiveNotification = YES;
                                        if (self.expectedObject) {
                                            self.didReceiveNotification &= (self.expectedObject==note.object);
                                        }
                                        if (self.expectedUserInfo) {
                                            self.didReceiveNotification &= [self.expectedUserInfo isEqualToDictionary:[note userInfo]];
                                        }
                                        if (self.evaluationBlock) {
                                            self.evaluationBlock(note);
                                        }
                                        if (self.didReceiveNotification) {
                                            [self removeObserver];
                                        }
                                    }];
}

- (void)removeObserver {
    if (self.observer) {
        [[NSNotificationCenter defaultCenter] removeObserver:self.observer];
        self.observer = nil;
    }
}

#pragma mark - Matching

- (BOOL)evaluate {
    if (!self.willEvaluateMultipleTimes) {
        [self removeObserver];
    }
    return self.didReceiveNotification;
}

- (void)dealloc {
    [self removeObserver];
}

- (BOOL)shouldBeEvaluatedAtEndOfExample {
    return YES;
}

#pragma mark - Getting Matcher Compatability

+ (BOOL)canMatchSubject:(id)anObject {
    return [anObject isKindOfClass:[NSString class]];
}

#pragma mark - Getting Failure Messages

- (NSString *)receiveNotificationMessage {
    NSMutableString *message = [NSMutableString stringWithFormat:@"receive %@ notification", [KWFormatter formatObject:self.subject]];
    if (self.expectedObject && self.expectedUserInfo) {
        [message appendFormat:@" with object: %@ and user info: %@", self.expectedObject, self.expectedUserInfo];
    } else if (self.expectedObject) {
        [message appendFormat:@" with object: %@", self.expectedObject];
    } else if (self.expectedUserInfo) {
        [message appendFormat:@" with user info: %@", self.expectedUserInfo];
    }
    return message;
}

- (NSString *)failureMessageForShould {
    return [NSString stringWithFormat:@"expect to %@", [self receiveNotificationMessage]];
}

- (NSString *)failureMessageForShouldNot {
    return [NSString stringWithFormat:@"expect not to %@, but received: %@",
            [self receiveNotificationMessage],
            self.notification];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ be posted", self.subject];
}

#pragma mark - Configuring Matchers

- (void)bePosted {
    [self addObserver];
}

- (void)bePostedWithObject:(id)object {
    [self addObserver];
    self.expectedObject = object;
}

- (void)bePostedWithUserInfo:(NSDictionary *)userInfo {
    [self addObserver];
    self.expectedUserInfo = userInfo;
}

- (void)bePostedWithObject:(id)object andUserInfo:(NSDictionary *)userInfo {
    [self bePostedWithObject:object userInfo:userInfo];
}

- (void)bePostedWithObject:(id)object userInfo:(NSDictionary *)userInfo {
    [self addObserver];
    self.expectedObject = object;
    self.expectedUserInfo = userInfo;
}

- (void)bePostedEvaluatingBlock:(PostedNotificationBlock)block {
    [self addObserver];
    self.evaluationBlock = block;
}

@end
