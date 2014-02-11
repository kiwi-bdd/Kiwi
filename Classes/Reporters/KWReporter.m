//
//  KWReporter.m
//  Kiwi
//
//  Created by Brian Ivan Gesiak on 2/12/14.
//  Copyright (c) 2014 Allen Ding. All rights reserved.
//

#import "KWReporter.h"
#import "KWListener.h"
#import "KWEventNotification.h"
#import "KWTextFormatter.h"

@interface KWReporter ()
@property (nonatomic, strong) NSMutableArray *listeners;
@end

@implementation KWReporter

#pragma mark - Initializing

+ (instancetype)sharedReporter {
    static KWReporter *sharedReporter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedReporter = [self new];

    });
    return sharedReporter;
}

- (id)init {
    self = [super init];
    if (self) {
        _listeners = [NSMutableArray array];
        [self registerListener:[KWTextFormatter new]];
    }
    return self;
}

#pragma mark - Public Interface

- (void)registerListener:(id<KWListener>)listener {
    [self.listeners addObject:listener];
}

#pragma mark - KWListener Protocol Methods

- (void)exampleStarted:(KWExample *)example {
    for (id<KWListener> listener in self.listeners) {
        if ([listener respondsToSelector:@selector(exampleStarted:)]) {
            [listener exampleStarted:[[KWEventNotification alloc] initWithExample:example]];
        }
    }
}

- (void)examplePending:(KWExample *)example {
    for (id<KWListener> listener in self.listeners) {
        if ([listener respondsToSelector:@selector(examplePending:)]) {
            [listener examplePending:[[KWEventNotification alloc] initWithExample:example]];
        }
    }
}

- (void)exampleFinished:(KWExample *)example {
    for (id<KWListener> listener in self.listeners) {
        if ([listener respondsToSelector:@selector(exampleFinished:)]) {
            [listener exampleFinished:[[KWEventNotification alloc] initWithExample:example]];
        }
    }
}

- (void)examplePassed:(KWExample *)example {
    for (id<KWListener> listener in self.listeners) {
        if ([listener respondsToSelector:@selector(examplePassed:)]) {
            [listener examplePassed:[[KWEventNotification alloc] initWithExample:example]];
        }
    }
}

- (void)exampleFailed:(KWExample *)example {
    for (id<KWListener> listener in self.listeners) {
        if ([listener respondsToSelector:@selector(exampleFailed:)]) {
            [listener exampleFailed:[[KWEventNotification alloc] initWithExample:example]];
        }
    }
}

@end
