//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWBlock.h"

@interface KWBlock()

#pragma mark - Properties

@property (nonatomic, readonly, assign) KWVoidBlock block;

@end

@implementation KWBlock

#pragma mark - Initializing

- (id)initWithBlock:(KWVoidBlock)aBlock {
    if ((self = [super init])) {
        block = Block_copy(aBlock);
    }

    return self;
}

+ (id)blockWithBlock:(KWVoidBlock)aBlock {
    return [[[self alloc] initWithBlock:aBlock] autorelease];
}

- (void)dealloc {
    Block_release(block);
    [super dealloc];
}

#pragma mark - Properties

@synthesize block;

#pragma mark - Calling Blocks

- (void)call {
    block();
}

@end

#pragma mark - Creating Blocks

KWBlock *theBlock(KWVoidBlock aBlock) {
    return lambda(aBlock);
}

KWBlock *lambda(KWVoidBlock aBlock) {
    return [KWBlock blockWithBlock:aBlock];
}
