//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWBlock.h"

@interface KWBlock()

#pragma mark -
#pragma mark Properties

@property (nonatomic, strong, readonly) KWVoidBlock block;

@end

@implementation KWBlock

#pragma mark -
#pragma mark Initializing

- (id)initWithBlock:(KWVoidBlock)aBlock {
    if ((self = [super init])) {
        _block = [aBlock copy];
    }

    return self;
}

+ (id)blockWithBlock:(KWVoidBlock)aBlock {
    return [[self alloc] initWithBlock:aBlock];
}

#pragma mark -
#pragma mark Calling Blocks

- (void)call {
    self.block();
}

@end

#pragma mark -
#pragma mark Creating Blocks

KWBlock *theBlock(KWVoidBlock aBlock) {
    return lambda(aBlock);
}

KWBlock *lambda(KWVoidBlock aBlock) {
    return [KWBlock blockWithBlock:aBlock];
}
