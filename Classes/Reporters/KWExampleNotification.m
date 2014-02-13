//
// Licensed under the terms in License.txt
//
// Copyright 2014 Allen Ding. All rights reserved.
//

#import "KWExampleNotification.h"

@interface KWExampleNotification ()
@property (nonatomic, strong) KWExample *example;
@end

@implementation KWExampleNotification

#pragma mark -  Initializing

- (id)initWithExample:(KWExample *)example {
    self = [super init];
    if (self) {
        _example = example;
    }
    return self;
}

@end
