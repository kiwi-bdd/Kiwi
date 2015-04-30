//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "TestSpy.h"

@implementation TestSpy

#pragma mark -
#pragma mark Checking Notifications

- (void)object:(id)anObject didReceiveInvocation:(NSInvocation *)anInvocation {
    _wasNotified = YES;
}

@end
