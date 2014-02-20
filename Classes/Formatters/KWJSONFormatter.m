//
// Licensed under the terms in License.txt
//
// Copyright 2014 Allen Ding. All rights reserved.
//

#import "KWJSONFormatter.h"
#import "KWFailure.h"

@interface KWJSONFormatter ()
@property (nonatomic, strong) NSMutableDictionary *output;
@property (nonatomic, strong) NSMutableArray *examples;
@end

@implementation KWJSONFormatter

#pragma mark - Initializing

- (id)initWithFileHandle:(NSFileHandle *)fileHandle {
    self = [super initWithFileHandle:fileHandle];
    if (self) {
        _output = [NSMutableDictionary dictionary];
        _examples = [NSMutableArray array];
    }
    return self;
}

#pragma mark - KWListener Protocol Methods

- (void)message:(KWMessageNotification *)notification {
    NSString *messagesKey = @"messages";
    if (!self.output[messagesKey]) {
        self.output[messagesKey] = [NSMutableArray array];
    }

    [self.output[messagesKey] addObject:notification.message];
}

- (void)exampleStarted:(KWExampleNotification *)notification {
    [self.examples addObject:notification.example];
}

- (void)dumpSummary:(KWSummaryNotification *)notification {
    self.output[@"summary"] = @{
        @"duration": @(notification.duration),
        @"example_count": @(notification.exampleCount),
        @"pending_count": @(notification.pendingCount),
        @"failure_count": @(notification.failureCount),
        @"summary_line": notification.summaryLine
    };
}

- (void)stop {
    NSMutableArray *examples = [NSMutableArray arrayWithCapacity:[self.examples count]];
    for (KWExample *example in self.examples) {
        [examples addObject:[self dictionaryFormat:example]];
    }

    self.output[@"examples"] = examples;
}

- (void)close {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.output
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    [self log:@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]];
}

#pragma mark - Internal Methods

- (NSDictionary *)dictionaryFormat:(KWExample *)example {
    NSMutableDictionary *exampleDictionary = [NSMutableDictionary dictionaryWithDictionary:@{
        @"description": [example descriptionWithContext],
        @"result": [self resultString:example.result]
    }];

    if (example.failure) {
        exampleDictionary[@"failure_message"] = example.failure.message;
    }

    if (example.exception) {
        NSDictionary *exceptionDictionary = @{
            @"name": example.exception.name,
            @"reason": example.exception.reason,
            @"call_stack_symbols": [example.exception callStackSymbols]
        };
        exampleDictionary[@"exception"] = exceptionDictionary;
    }

    return [exampleDictionary copy];
}

- (NSString *)resultString:(KWExampleResult)result {
    switch (result) {
        case KWExampleResultPassed:
            return @"passed";
        case KWExampleResultFailed:
            return @"failed";
        case KWExampleResultPending:
            return @"pending";
    }
}

@end
