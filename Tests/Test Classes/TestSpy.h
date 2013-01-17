//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"

@interface TestSpy : NSObject<KWMessageSpying> {
@private
    BOOL wasNotified;
}

#pragma mark -
#pragma mark Initializing

+ (id)testSpy;

#pragma mark -
#pragma mark Checking Notifications

@property (nonatomic, readonly) BOOL wasNotified;

@end
