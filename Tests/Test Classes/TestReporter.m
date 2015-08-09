//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "TestReporter.h"
#import "KWFailure.h"

@interface TestReporter() {
    NSMutableArray *_failures;
}

#pragma mark -
#pragma mark Properties

@property (nonatomic, readwrite) BOOL hasUnmetExpectations;

@end

@implementation TestReporter

#pragma mark -
#pragma mark Initializing

- (id)init {
    self = [super init];
    if (self) {
        _failures = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark -
#pragma mark Reporting Failures

- (void)reportFailure:(KWFailure *)aFailure {
    if (aFailure == nil)
        return;

    self.hasUnmetExpectations = YES;
    [_failures addObject:aFailure];
}

#pragma mark -
#pragma mark Getting Failure Information

- (BOOL)hasNoFailure {
    return [self.failures count] == 0;
}

- (BOOL)hasOneFailure {
    return [self.failures count] == 1;
}

- (KWFailure *)onlyFailure {
    return (self.failures)[0];
}

@end
