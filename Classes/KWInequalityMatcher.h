//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"
#import "KWMatcher.h"

enum {
    KWInequalityTypeLessThan,
    KWInequalityTypeLessThanOrEqualTo,
    KWInequalityTypeGreaterThan,
    KWInequalityTypeGreaterThanOrEqualTo
};

typedef NSUInteger KWInequalityType;

@interface KWInequalityMatcher : KWMatcher

#pragma mark - Configuring Matchers

- (void)beLessThan:(id)aValue;
- (void)beLessThanOrEqualTo:(id)aValue;
- (void)beGreaterThan:(id)aValue;
- (void)beGreaterThanOrEqualTo:(id)aValue;

@end
