//
// Licensed under the terms in License.txt
//
// Copyright 2014 Allen Ding. All rights reserved.
//

#import "KWSummaryNotification.h"

@interface KWSummaryNotification ()
@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, assign) NSUInteger exampleCount;
@property (nonatomic, assign) NSUInteger failureCount;
@property (nonatomic, assign) NSUInteger pendingCount;
@end

@implementation KWSummaryNotification

#pragma mark - Initializing

- (id)initWithDuration:(NSTimeInterval)duration
          exampleCount:(NSUInteger)exampleCount
          failureCount:(NSUInteger)failureCount
          pendingCount:(NSUInteger)pendingCount {
    self = [super init];
    if (self) {
        _duration = duration;
        _exampleCount = exampleCount;
        _failureCount = failureCount;
        _pendingCount = pendingCount;
    }
    return self;
}

- (NSString *)summaryLine {
    NSString *examples = [self pluralize:@"example" count:self.exampleCount];
    NSMutableString *line = [NSMutableString stringWithString:examples];
    if (self.failureCount > 0) {
        NSString *failures = [self pluralize:@"failure" count:self.failureCount];
        [line appendString:[NSString stringWithFormat:@", %@", failures]];
    }
    if (self.pendingCount > 0) {
        NSString *pending = [self pluralize:@"pending" count:self.pendingCount];
        [line appendString:[NSString stringWithFormat:@", %@", pending]];
    }
    return [line copy];
}

- (NSString *)pluralize:(NSString *)string count:(NSInteger)count {
    if (count == 1) {
        return [NSString stringWithFormat:@"%d %@", count, string];
    } else {
        return [NSString stringWithFormat:@"%d %@s", count, string];
    }
}

@end
