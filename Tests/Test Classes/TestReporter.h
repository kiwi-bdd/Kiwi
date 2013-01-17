//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KWReporting.h"

@class KWFailure;

@interface TestReporter : NSObject<KWReporting> {
@private
    BOOL hasUnmetExpectations;
    NSMutableArray *failures;
}

#pragma mark -
#pragma mark Initializing

+ (id)testReporter;

#pragma mark -
#pragma mark Properties

@property (nonatomic, readonly) BOOL hasUnmetExpectations;
@property (nonatomic, readonly) NSArray* failures;

#pragma mark -
#pragma mark Reporting Failures

- (void)reportFailure:(KWFailure *)aFailure;

#pragma mark -
#pragma mark Getting Failure Information

- (BOOL)hasNoFailure;
- (BOOL)hasOneFailure;
- (KWFailure *)onlyFailure;

@end
