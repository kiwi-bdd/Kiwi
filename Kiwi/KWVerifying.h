//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"

@protocol KWVerifying<NSObject>

#pragma mark -
#pragma mark Setting Subjects

- (void)setSubject:(id)anObject;

#pragma mark -
#pragma mark Ending Examples

- (void)exampleWillEnd;

@end
