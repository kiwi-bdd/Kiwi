//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "TestReporter.h"
#import "KWFailure.h"

@interface TestReporter()

#pragma mark -
#pragma mark Properties

@property (nonatomic, readwrite) BOOL hasUnmetExpectations;

@end

@implementation TestReporter

#pragma mark -
#pragma mark Initializing

- (id)init {
    if ((self = [super init])) {
        failures = [[NSMutableArray alloc] init];
    }

    return self;
}

+ (id)testReporter {
    return [[[self alloc] init] autorelease];
}

- (void)dealloc {
    [failures release];
    [super dealloc];
}

#pragma mark -
#pragma mark Properties

@synthesize hasUnmetExpectations;
@synthesize failures;

#pragma mark -
#pragma mark Reporting Failures

- (void)reportFailure:(KWFailure *)aFailure {
    if (aFailure == nil)
        return;

    self.hasUnmetExpectations = YES;
    [failures addObject:aFailure];
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
