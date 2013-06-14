//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWRegisterMatchersNode.h"

#import "KWCallSite.h"
#import "KWExampleNodeVisitor.h"

@implementation KWRegisterMatchersNode

#pragma mark - Initializing

- (id)initWithCallSite:(KWCallSite *)aCallSite namespacePrefix:(NSString *)aNamespacePrefix {
    if ((self = [super init])) {
        callSite = aCallSite;
        namespacePrefix = [aNamespacePrefix copy];
    }

    return self;
}

+ (id)registerMatchersNodeWithCallSite:(KWCallSite *)aCallSite namespacePrefix:(NSString *)aNamespacePrefix {
    return [[self alloc] initWithCallSite:aCallSite namespacePrefix:aNamespacePrefix];
}


#pragma mark - Getting Call Sites

@synthesize callSite;

#pragma mark - Getting Namespace Prefixes

@synthesize namespacePrefix;

#pragma mark - Accepting Visitors

- (void)acceptExampleNodeVisitor:(id<KWExampleNodeVisitor>)aVisitor {
    [aVisitor visitRegisterMatchersNode:self];
}

@end
