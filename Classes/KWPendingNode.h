//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"
#import "KWExampleNode.h"

@class KWContextNode;
@class KWCallSite;

@interface KWPendingNode : NSObject<KWExampleNode>

@property (nonatomic, strong, readonly) KWContextNode *context;
@property (nonatomic, strong, readonly) KWCallSite *callSite;
@property (nonatomic, copy, readonly) NSString *description;

#pragma mark -
#pragma mark Initializing

- (id)initWithCallSite:(KWCallSite *)aCallSite context:(KWContextNode *)context description:(NSString *)aDescription;

+ (id)pendingNodeWithCallSite:(KWCallSite *)aCallSite context:(KWContextNode *)context description:(NSString *)aDescription;

@end
