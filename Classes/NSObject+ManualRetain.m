//
// Licensed under the terms in License.txt
//
// Copyright 2013 Stepan Hruda. All rights reserved.
//

#import "NSObject+ManualRetain.h"

@implementation NSObject (ManualRetain)

- (void)manualRetain {
    [self retain];
}

@end
