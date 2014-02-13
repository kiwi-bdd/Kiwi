//
//  KWSummaryNotification.h
//  Kiwi
//
//  Created by Brian Ivan Gesiak on 2/12/14.
//  Copyright (c) 2014 Allen Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KWSummaryNotification : NSObject

@property (nonatomic, assign, readonly) NSTimeInterval duration;
@property (nonatomic, assign, readonly) NSUInteger exampleCount;
@property (nonatomic, assign, readonly) NSUInteger failureCount;
@property (nonatomic, assign, readonly) NSUInteger pendingCount;
@property (nonatomic, readonly) NSString *summaryLine;

- (id)initWithDuration:(NSTimeInterval)duration
          exampleCount:(NSUInteger)exampleCount
          failureCount:(NSUInteger)failureCount
          pendingCount:(NSUInteger)pendingCount;

@end
