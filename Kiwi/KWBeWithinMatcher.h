//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"
#import "KWMatcher.h"

@interface KWBeWithinMatcher : KWMatcher {
@private
    id distance;
    id otherValue;
}

#pragma mark -
#pragma mark Configuring Matchers

- (void)beWithin:(id)aDistance of:(id)aValue;
- (void)equal:(double)aValue withDelta:(double)aDelta;

@end
