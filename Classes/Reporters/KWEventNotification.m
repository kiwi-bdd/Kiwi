//
//  KWEventNotification.m
//  Kiwi
//
//  Created by Brian Ivan Gesiak on 2/12/14.
//  Copyright (c) 2014 Allen Ding. All rights reserved.
//

#import "KWEventNotification.h"

@interface KWEventNotification ()
@property (nonatomic, strong) KWExample *example;
@end

@implementation KWEventNotification

#pragma mark -  Initializing

- (id)initWithExample:(KWExample *)example {
    self = [super init];
    if (self) {
        _example = example;
    }
    return self;
}

@end
