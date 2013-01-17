//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "TestSpy.h"

@implementation TestSpy

#pragma mark -
#pragma mark Initializing

+ (id)testSpy {
    return [[[self alloc] init] autorelease];
}

#pragma mark -
#pragma mark Checking Notifications

@synthesize wasNotified;

- (void)object:(id)anObject didReceiveInvocation:(NSInvocation *)anInvocation {
    wasNotified = YES;
}

@end
