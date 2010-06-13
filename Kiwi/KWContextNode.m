//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWContextNode.h"
#import "KWExampleNodeVisitor.h"

#if KW_BLOCKS_ENABLED

@implementation KWContextNode

#pragma mark -
#pragma mark Initializing

- (id)initWithCallSite:(KWCallSite *)aCallSite description:(NSString *)aDescription {
    if ((self = [super init])) {
        callSite = [aCallSite retain];
        description = [aDescription copy];
        nodes = [[NSMutableArray alloc] init];
    }
    
    return self;
}

+ (id)contextNodeWithCallSite:(KWCallSite *)aCallSite description:(NSString *)aDescription {
    return [[[self alloc] initWithCallSite:aCallSite description:aDescription] autorelease];
}

- (void)dealloc {
    [callSite release];
    [description release];
    [registerMatchersNode release];
    [beforeAllNode release];
    [afterAllNode release];
    [beforeEachNode release];
    [afterEachNode release];
    [nodes release];
    [super dealloc];
}

#pragma mark -
#pragma mark  Getting Call Sites

@synthesize callSite;

#pragma mark -
#pragma mark Getting Descriptions

@synthesize description;

#pragma mark -
#pragma mark Managing Nodes

@synthesize registerMatchersNode;
@synthesize beforeAllNode;
@synthesize afterAllNode;
@synthesize beforeEachNode;
@synthesize afterEachNode;
@synthesize nodes;

- (void)addContextNode:(KWContextNode *)aNode {
    [(NSMutableArray *)self.nodes addObject:aNode];
}

- (void)setRegisterMatchersNode:(KWRegisterMatchersNode *)aNode {
    if (self.registerMatchersNode != nil)
        [NSException raise:@"KWContextNodeException" format:@"a register matchers node already exists"];
    
    registerMatchersNode = [aNode retain];
}

- (void)setBeforeEachNode:(KWBeforeEachNode *)aNode {
    if (self.beforeEachNode != nil)
        [NSException raise:@"KWContextNodeException" format:@"a before each node already exists"];
    
    beforeEachNode = [aNode retain];
}

- (void)setAfterEachNode:(KWAfterEachNode *)aNode {
    if (self.afterEachNode != nil)
        [NSException raise:@"KWContextNodeException" format:@"an after each node already exists"];
    
    afterEachNode = [aNode retain];
}

- (void)addItNode:(KWItNode *)aNode {
    [(NSMutableArray *)self.nodes addObject:aNode];
}

- (void)addPendingNode:(KWPendingNode *)aNode {
    [(NSMutableArray *)self.nodes addObject:aNode];
}

#pragma mark -
#pragma mark Accepting Visitors

- (void)acceptExampleNodeVisitor:(id<KWExampleNodeVisitor>)aVisitor {
    [aVisitor visitContextNode:self];
}

@end

#endif // #if KW_BLOCKS_ENABLED
