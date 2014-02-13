//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"

@class KWFailure;

@protocol KWFailureReporting<NSObject>

#pragma mark - Reporting Failures

- (void)reportFailure:(KWFailure *)failure;

@end
