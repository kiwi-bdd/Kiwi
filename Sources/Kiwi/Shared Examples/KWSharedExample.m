//
// Licensed under the terms in License.txt
//
// Copyright 2014 Allen Ding. All rights reserved.
//

#import "KWSharedExample.h"
#import "KWSharedExampleRegistry.h"
#import "KWExample.h"

@implementation KWSharedExample

#pragma mark - Initializing

- (id)initWithName:(NSString *)name block:(KWSharedExampleBlock)block {
    NSParameterAssert(name);
    NSParameterAssert(block);

    self = [super init];
    if (self) {
        _name = name;
        _block = block;
    }
    return self;
}

@end

#pragma mark - Building Example Groups

void sharedExamplesFor(NSString *name, KWSharedExampleBlock block) {
    KWSharedExample *sharedExample = [[KWSharedExample alloc] initWithName:name block:block];
    [[KWSharedExampleRegistry sharedRegistry] registerSharedExample:sharedExample];
}

void itBehavesLike(NSString *name, NSDictionary *data) {
    KWSharedExample *sharedExample = [[KWSharedExampleRegistry sharedRegistry] sharedExampleForName:name];
    NSString *description = [NSString stringWithFormat:@"behaves like %@", sharedExample.name];
    context(description, ^{ sharedExample.block(data); });
}
