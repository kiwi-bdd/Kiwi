//
//  KWReporter.m
//  Kiwi
//
//  Created by Brian Ivan Gesiak on 2/12/14.
//  Copyright (c) 2014 Allen Ding. All rights reserved.
//

#import "KWReporter.h"
#import "KWListener.h"
#import "KiwiConfiguration.h"
#import "KWExampleNotification.h"
#import "KWTextFormatter.h"
#import "KWFormatterLoader.h"
#import "KWClassLoading.h"
#import "KWSpec.h"

@interface KWReporter ()
@property (nonatomic, strong) NSMutableArray *specClasses;
@property (nonatomic, strong) NSMutableArray *listeners;
@property (nonatomic, assign) NSUInteger completedSpecCount;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *stopDate;
@property (nonatomic, assign) NSUInteger exampleCount;
@property (nonatomic, assign) NSUInteger pendingCount;
@property (nonatomic, assign) NSUInteger failureCount;
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
        _specClasses = [NSMutableArray array];
        [self registerFormatters];
    }
    return self;
}

#pragma mark - Public Interface

- (void)registerSpecClass:(Class)specClass {
    [self.specClasses addObject:specClass];
}

- (void)registerListener:(id<KWListener>)listener {
    [self.listeners addObject:listener];
}

#pragma mark - KWListener Protocol Methods

- (void)specStarted:(KWSpec *)spec {
    if (self.completedSpecCount == 0) {
        [self notify:@selector(start) notification:nil];
    }
}

- (void)message:(NSString *)message {
    [self notify:@selector(message:)
    notification:[[KWMessageNotification alloc] initWithMessage:message]];
}

- (void)exampleStarted:(KWExample *)example {
    ++self.exampleCount;
    [self notify:@selector(exampleStarted:)
    notification:[[KWExampleNotification alloc] initWithExample:example]];
}

- (void)examplePending:(KWExample *)example {
    ++self.pendingCount;
    [self notify:@selector(examplePending:)
    notification:[[KWExampleNotification alloc] initWithExample:example]];
}

- (void)exampleFinished:(KWExample *)example {
    [self notify:@selector(exampleFinished:)
    notification:[[KWExampleNotification alloc] initWithExample:example]];
}

- (void)examplePassed:(KWExample *)example {
    [self notify:@selector(examplePassed:)
    notification:[[KWExampleNotification alloc] initWithExample:example]];
}

- (void)exampleFailed:(KWExample *)example {
    ++self.failureCount;
    [self notify:@selector(exampleFailed:)
    notification:[[KWExampleNotification alloc] initWithExample:example]];
}

- (void)specFinished:(KWSpec *)spec {
    ++self.completedSpecCount;

    if (self.completedSpecCount == [self.specClasses count]) {
        [self stop];
    }
}

#pragma mark - Internal Methods

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

- (void)notify:(SEL)selector notification:(id)notification {
    for (id<KWListener> listener in self.listeners) {
        if ([listener respondsToSelector:selector]) {
            [listener performSelector:selector withObject:notification];
        }
    }
}

#pragma clang diagnostic pop

- (void)stop {
    @try {
        NSTimeInterval timeInterval = [self.stopDate timeIntervalSinceDate:self.startDate];
        [self notify:@selector(stop) notification:nil];

        [self notify:@selector(startDump) notification:nil];
        [self notify:@selector(dumpPending) notification:nil];
        [self notify:@selector(dumpFailures) notification:nil];

        KWSummaryNotification *notification =
            [[KWSummaryNotification alloc] initWithDuration:timeInterval
                                               exampleCount:self.exampleCount
                                               failureCount:self.failureCount
                                               pendingCount:self.pendingCount];
        [self notify:@selector(dumpSummary:) notification:notification];
    }
    @finally {
        [self notify:@selector(close) notification:nil];
    }
}

- (void)registerFormatters {
    for (id<KWListener> formatter in [KWFormatterLoader formatters]) {
        [self registerListener:formatter];
    }
}

@end
