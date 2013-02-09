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

@synthesize context = _context;

#pragma mark -
#pragma mark Initializing

- (id)initWithCallSite:(KWCallSite *)aCallSite context:(KWContextNode *)context description:(NSString *)aDescription {
    if ((self = [super init])) {
        callSite = aCallSite;
        description = [aDescription copy];
        _context = context;
    }

    return self;
}

+ (id)pendingNodeWithCallSite:(KWCallSite *)aCallSite context:(KWContextNode *)context description:(NSString *)aDescription {
    return [[self alloc] initWithCallSite:aCallSite context:context description:aDescription];
}


#pragma mark -
#pragma mark Getting Call Sites

@synthesize callSite;

#pragma mark -
#pragma mark Getting Descriptions

@synthesize description;

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
    
    KWContextNode *currentContext = _context;
    
    while (currentContext) {
        [contextStack addObject:currentContext];
        currentContext = currentContext.parentContext;
    }
    return contextStack;
}

@end
