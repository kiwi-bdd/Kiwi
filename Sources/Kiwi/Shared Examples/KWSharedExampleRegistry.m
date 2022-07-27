//
// Licensed under the terms in License.txt
//
// Copyright 2014 Allen Ding. All rights reserved.
//

#import "KWSharedExampleRegistry.h"
#import "KWSharedExample.h"

@interface KWSharedExampleRegistry ()
@property (nonatomic, strong) NSMutableDictionary *sharedExamples;
@end

@implementation KWSharedExampleRegistry

#pragma mark - Initializing

+ (instancetype)sharedRegistry {
    static KWSharedExampleRegistry *sharedRegistry = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedRegistry = [self new];

    });
    return sharedRegistry;
}

- (id)init {
    self = [super init];
    if (self) {
        _sharedExamples = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - Public Interface

- (KWSharedExample *)sharedExampleForName:(NSString *)name {
    [self raiseIfSharedExampleNotRegistered:name];
    return [_sharedExamples objectForKey:name];
}

- (void)registerSharedExample:(KWSharedExample *)sharedExample {
    [self raiseIfSharedExampleAlreadyRegistered:sharedExample];
    [_sharedExamples setObject:sharedExample forKey:sharedExample.name];
}

#pragma mark - Internal Methods

- (void)raiseIfSharedExampleNotRegistered:(NSString *)name {
    if (![_sharedExamples objectForKey:name]) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"Kiwi shared example error: No shared example registered for '%@'",
                           name];
    }
}

- (void)raiseIfSharedExampleAlreadyRegistered:(KWSharedExample *)sharedExample {
    if ([_sharedExamples objectForKey:sharedExample.name]) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"Kiwi shared example error: Shared example already registered for '%@'",
                           sharedExample.name];
    }
}

@end
