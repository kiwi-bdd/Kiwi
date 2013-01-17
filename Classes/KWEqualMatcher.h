//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"
#import "KWMatcher.h"

@interface KWEqualMatcher : KWMatcher {
@private
    id otherSubject;
}

#pragma mark -
#pragma mark Configuring Matchers

- (void)equal:(id)anObject;

@end
