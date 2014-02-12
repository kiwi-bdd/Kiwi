//
//  KWSummaryNotification.m
//  Kiwi
//
//  Created by Brian Ivan Gesiak on 2/12/14.
//  Copyright (c) 2014 Allen Ding. All rights reserved.
//

#import "KWSummaryNotification.h"

@interface KWSummaryNotification ()
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) NSUInteger exampleCount;
@property (nonatomic, assign) NSUInteger failureCount;
@property (nonatomic, assign) NSUInteger pendingCount;
@end

@implementation KWSummaryNotification

#pragma mark - Initializing

- (id)initWithDuration:(NSTimeInterval)duration
          exampleCount:(NSUInteger)exampleCount
          failureCount:(NSUInteger)failureCount
          pendingCount:(NSUInteger)pendingCount {
    self = [super init];
    if (self) {
        _duration = duration;
        _exampleCount = exampleCount;
        _failureCount = failureCount;
        _pendingCount = pendingCount;
    }
    return self;
}

@end
