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
@property (nonatomic, assign) BOOL didReceiveNotification;
@end

@implementation KWNotificationMatcher

+ (NSArray *)matcherStrings {
    return @[@"bePosted:"];
}

- (void)addObserver {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    self.observer = [center addObserverForName:self.subject
                                        object:nil
                                         queue:nil
                                    usingBlock:^(NSNotification *note) {
                                        self.didReceiveNotification = YES;
                                        self.notification = note;
                                        if (self.evaluationBlock) {
                                            self.evaluationBlock(note);
                                        }
                                    }];
}

#pragma mark - Matching

- (BOOL)evaluate {
    [[NSNotificationCenter defaultCenter] removeObserver:self.observer];
    return self.didReceiveNotification;
}

- (BOOL)shouldBeEvaluatedAtEndOfExample {
    return YES;
}

#pragma mark - Getting Matcher Compatability

+ (BOOL)canMatchSubject:(id)anObject {
    return [anObject isKindOfClass:[NSString class]];
}

#pragma mark - Getting Failure Messages

- (NSString *)failureMessageForShould {
    return [NSString stringWithFormat:@"expect to receive %@ notification", [KWFormatter formatObject:self.subject]];
}

- (NSString *)failureMessageForShouldNot {
    return [NSString stringWithFormat:@"expect not to receive %@ notification, but received: %@",
            [KWFormatter formatObject:self.subject],
            self.notification];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ be posted", self.subject];
}

#pragma mark - Configuring Matchers

- (void)bePosted:(PostedNotificationBlock)block {
    [self addObserver];
    self.evaluationBlock = block;
}


@end
