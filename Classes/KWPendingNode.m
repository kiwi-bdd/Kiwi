//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWPendingNode.h"

#import "KWCallSite.h"
#import "KWExampleNodeVisitor.h"
#import "KWContextNode.h"

@implementation KWPendingNode

#pragma mark -
#pragma mark Initializing

- (id)initWithCallSite:(KWCallSite *)aCallSite context:(KWContextNode *)context description:(NSString *)aDescription {
    if ((self = [super init])) {
        _callSite = aCallSite;
        _description = [aDescription copy];
        _context = context;
    }

    return self;
}

+ (id)pendingNodeWithCallSite:(KWCallSite *)aCallSite context:(KWContextNode *)context description:(NSString *)aDescription {
    return [[self alloc] initWithCallSite:aCallSite context:context description:aDescription];
}

#pragma mark -
#pragma mark Accepting Visitors

- (void)acceptExampleNodeVisitor:(id<KWExampleNodeVisitor>)aVisitor {
    [aVisitor visitPendingNode:self];
}

#pragma mark -
#pragma mark - Accessing the context stack

- (NSArray *)contextStack
{
    NSMutableArray *contextStack = [NSMutableArray array];
    
    KWContextNode *currentContext = self.context;
    
    while (currentContext) {
        [contextStack addObject:currentContext];
        currentContext = currentContext.parentContext;
    }
    return contextStack;
}

@end
