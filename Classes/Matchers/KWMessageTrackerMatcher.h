//
//  KWMessageTrackerMatcher.h
//  Kiwi
//
//  Created by Oleksa 'trimm' Korin on 4/20/16.
//  Copyright © 2016 Allen Ding. All rights reserved.
//

#import "KWMatcher.h"

#import "KWCountType.h"

@class KWMessageTracker;
@class KWMessagePattern;

@interface KWMessageTrackerMatcher : KWMatcher

#pragma mark - Properties

@property (nonatomic, readonly) KWMessageTracker *messageTracker;
@property (nonatomic, assign) BOOL willEvaluateMultipleTimes;
@property (nonatomic, assign) BOOL willEvaluateAgainstNegativeExpectation;

@end

// methods in this category are used for inheritance and should not be called directly
@interface KWMessageTrackerMatcher (KWKWMessageTrackerMatcherPrivate)

- (void)setMessageTrackerWithMessagePattern:(KWMessagePattern *)aMessagePattern
                                  countType:(KWCountType)aCountType
                                      count:(NSUInteger)aCount;

@end
