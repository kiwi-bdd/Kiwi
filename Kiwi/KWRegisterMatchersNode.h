//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"
#import "KWExampleNode.h"

@class KWCallSite;

@interface KWRegisterMatchersNode : NSObject<KWExampleNode> {
@private
    KWCallSite *callSite;
    NSString *namespacePrefix;
}

#pragma mark -
#pragma mark Initializing

- (id)initWithCallSite:(KWCallSite *)aCallSite namespacePrefix:(NSString *)aNamespacePrefix;

+ (id)registerMatchersNodeWithCallSite:(KWCallSite *)aCallSite namespacePrefix:(NSString *)aNamespacePrefix;

#pragma mark -
#pragma mark Getting Call Sites

@property (nonatomic, readonly) KWCallSite *callSite;

#pragma mark -
#pragma mark Getting Namespace Prefixes

@property (nonatomic, readonly) NSString *namespacePrefix;

@end
