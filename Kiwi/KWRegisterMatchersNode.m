//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWRegisterMatchersNode.h"
#import "KWExampleNodeVisitor.h"

#if KW_BLOCKS_ENABLED

@implementation KWRegisterMatchersNode

#pragma mark -
#pragma mark Initializing

- (id)initWithCallSite:(KWCallSite *)aCallSite namespacePrefix:(NSString *)aNamespacePrefix {
    if ((self = [super init])) {
        callSite = [aCallSite retain];
        namespacePrefix = [aNamespacePrefix copy];
    }
    
    return self;
}

+ (id)registerMatchersNodeWithCallSite:(KWCallSite *)aCallSite namespacePrefix:(NSString *)aNamespacePrefix {
    return [[[self alloc] initWithCallSite:aCallSite namespacePrefix:aNamespacePrefix] autorelease];
}

- (void)dealloc {
    [callSite release];
    [namespacePrefix release];
    [super dealloc];
}

#pragma mark -
#pragma mark Getting Call Sites

@synthesize callSite;

#pragma mark -
#pragma mark Getting Namespace Prefixes

@synthesize namespacePrefix;

#pragma mark -
#pragma mark Accepting Visitors

- (void)acceptExampleNodeVisitor:(id<KWExampleNodeVisitor>)aVisitor {
    [aVisitor visitRegisterMatchersNode:self];
}

@end

#endif // #if KW_BLOCKS_ENABLED
