//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWBlockNode.h"
#import "KWCallSite.h"

@implementation KWBlockNode

#pragma mark -
#pragma mark Initializing

- (id)initWithCallSite:(KWCallSite *)aCallSite description:(NSString *)aDescription block:(KWVoidBlock)aBlock{
    if ((self = [super init])) {
        _callSite = aCallSite;
        _description = [aDescription copy];

        if (aBlock != nil)
            _block = [aBlock copy];
    }
    return self;
}


- (void)performBlock
{
  if (self.block) { self.block(); }
}

@end
