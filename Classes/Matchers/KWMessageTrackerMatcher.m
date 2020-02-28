//
//  KWMessageTrackerMatcher.m
//  Kiwi
//
//  Created by Oleksa 'trimm' Korin on 4/20/16.
//  Copyright © 2016 Allen Ding. All rights reserved.
//

#import "KWMessageTrackerMatcher.h"

#import "KWMessageTracker.h"
#import "KWMessagePattern.h"

@interface KWMessageTrackerMatcher ()

@property (nonatomic, strong) KWMessageTracker *messageTracker;

@end

@implementation KWMessageTrackerMatcher

#pragma mark - Initializing

- (id)initWithSubject:(id)anObject {
    self = [super initWithSubject:anObject];
    if (self) {
        _willEvaluateMultipleTimes = NO;
    }
    
    return self;
}

#pragma mark - Matching

- (BOOL)shouldBeEvaluatedAtEndOfExample {
    return YES;
}

- (BOOL)evaluate {
    BOOL succeeded = [self.messageTracker succeeded];
    
    if (!self.willEvaluateMultipleTimes) {
        [self.messageTracker stopTracking];
    }
    return succeeded;
}

#pragma mark - Getting Failure Messages

- (NSString *)failureMessageForShould {
    return [NSString stringWithFormat:@"expected subject to receive -%@ %@, but received it %@",
            [self.messageTracker.messagePattern stringValue],
            [self.messageTracker expectedCountPhrase],
            [self.messageTracker receivedCountPhrase]];
}

- (NSString *)failureMessageForShouldNot {
    return [NSString stringWithFormat:@"expected subject not to receive -%@, but received it %@",
            [self.messageTracker.messagePattern stringValue],
            [self.messageTracker receivedCountPhrase]];
}

#pragma mark - Setting Message Tracker

- (void)setMessageTrackerWithMessagePattern:(KWMessagePattern *)aMessagePattern
                                  countType:(KWCountType)aCountType
                                      count:(NSUInteger)aCount
{
    self.messageTracker = [KWMessageTracker messageTrackerWithSubject:self.subject messagePattern:aMessagePattern countType:aCountType count:aCount];
}

@end
