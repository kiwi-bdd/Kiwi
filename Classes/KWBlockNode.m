//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWBlockNode.h"

@implementation KWBlockNode

#pragma mark - Initializing

- (id)initWithCallSite:(KWCallSite *)aCallSite description:(NSString *)aDescription block:(KWVoidBlock)aBlock {
    if ((self = [super init])) {
        callSite = [aCallSite retain];
        _description = [aDescription copy];

        if (aBlock != nil)
            block = Block_copy(aBlock);
    }

    return self;
}

- (void)dealloc {
    [callSite release];
    [_description release];

    if (block != nil)
        Block_release(block);

    [super dealloc];
}

- (void)performBlock {
    if (block != nil) { block(); }
}

#pragma mark - Getting Call Sites

@synthesize callSite;

#pragma mark - Accepting Visitors

@synthesize block;

@end
