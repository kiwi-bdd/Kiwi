//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWBeforeAllNode.h"
#import "KWExampleNodeVisitor.h"

@implementation KWBeforeAllNode

#pragma mark - Initializing

+ (id)beforeAllNodeWithCallSite:(KWCallSite *)aCallSite block:(KWVoidBlock)aBlock {
    return [[[self alloc] initWithCallSite:aCallSite description:nil block:aBlock] autorelease];
}

#pragma mark - Accepting Visitors

- (void)acceptExampleNodeVisitor:(id<KWExampleNodeVisitor>)aVisitor {
    [aVisitor visitBeforeAllNode:self];
}

@end
