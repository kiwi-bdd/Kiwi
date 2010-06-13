//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWPendingNode.h"
#import "KWExampleNodeVisitor.h"

#if KW_BLOCKS_ENABLED

@implementation KWPendingNode

#pragma mark -
#pragma mark Initializing

- (id)initWithCallSite:(KWCallSite *)aCallSite description:(NSString *)aDescription {
    if ((self = [super init])) {
        callSite = [aCallSite retain];
        description = [aDescription copy];
    }
    
    return self;
}

+ (id)pendingNodeWithCallSite:(KWCallSite *)aCallSite description:(NSString *)aDescription {
    return [[[self alloc] initWithCallSite:aCallSite description:aDescription] autorelease];
}

- (void)dealloc {
    [callSite release];
    [description release];
    [super dealloc];
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

@end

#endif // #if KW_BLOCKS_ENABLED
