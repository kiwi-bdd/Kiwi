//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"
#import "KWExampleNode.h"

@class KWCallSite;

@interface KWRegisterMatchersNode : NSObject<KWExampleNode>

@property (nonatomic, strong, readonly) KWCallSite *callSite;
@property (nonatomic, copy, readonly) NSString *namespacePrefix;

#pragma mark -
#pragma mark Initializing

- (id)initWithCallSite:(KWCallSite *)aCallSite namespacePrefix:(NSString *)aNamespacePrefix;

+ (id)registerMatchersNodeWithCallSite:(KWCallSite *)aCallSite namespacePrefix:(NSString *)aNamespacePrefix;

@end
