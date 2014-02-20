//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"
#import "KWMatcher.h"

@interface KWRaiseMatcher : KWMatcher

#pragma mark - Configuring Matchers

- (void)raiseWhenSent:(SEL)aSelector DEPRECATED_ATTRIBUTE; 
- (void)raiseWithName:(NSString *)aName whenSent:(SEL)aSelector DEPRECATED_ATTRIBUTE;
- (void)raiseWithReason:(NSString *)aReason whenSent:(SEL)aSelector DEPRECATED_ATTRIBUTE;
- (void)raiseWithName:(NSString *)aName reason:(NSString *)aReason whenSent:(SEL)aSelector DEPRECATED_ATTRIBUTE;

@end
