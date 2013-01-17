//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"
#import "KWMatcher.h"

@interface KWBeBetweenMatcher : KWMatcher {
@private
    id lowerEndpoint;
    id upperEndpoint;
}

#pragma mark -
#pragma mark Configuring Matchers

// TODO: 'and' below is a reserved word in C++
- (void)beBetween:(id)aLowerEndpoint and:(id)anUpperEndpoint;
- (void)beInTheIntervalFrom:(id)aLowerEndpoint to:(id)anUpperEndpoint;

@end
