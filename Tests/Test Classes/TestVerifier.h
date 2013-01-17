//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"

@interface TestVerifier : NSObject<KWVerifying> {
@private
    BOOL notifiedOfEndOfExample;
}

#pragma mark -
#pragma mark Properties

@property (nonatomic, readonly) BOOL notifiedOfEndOfExample;

#pragma mark -
#pragma mark Verifying

- (void)exampleWillEnd;

@end
