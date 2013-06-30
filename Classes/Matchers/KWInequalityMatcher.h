//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"
#import "KWMatcher.h"

typedef NS_ENUM(NSUInteger, KWInequalityType) {
    KWInequalityTypeLessThan,
    KWInequalityTypeLessThanOrEqualTo,
    KWInequalityTypeGreaterThan,
    KWInequalityTypeGreaterThanOrEqualTo
};

@interface KWInequalityMatcher : KWMatcher

#pragma mark - Configuring Matchers

- (void)beLessThan:(id)aValue;
- (void)beLessThanOrEqualTo:(id)aValue;
- (void)beGreaterThan:(id)aValue;
- (void)beGreaterThanOrEqualTo:(id)aValue;

@end
