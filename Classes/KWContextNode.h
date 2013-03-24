//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"
#import "KWExampleNode.h"

@class KWAfterAllNode;
@class KWAfterEachNode;
@class KWBeforeAllNode;
@class KWBeforeEachNode;
@class KWCallSite;
@class KWItNode;
@class KWPendingNode;
@class KWRegisterMatchersNode;
@class KWExample;

@interface KWContextNode : NSObject<KWExampleNode>

#pragma mark -
#pragma mark Initializing

- (id)initWithCallSite:(KWCallSite *)aCallSite parentContext:(KWContextNode *)node description:(NSString *)aDescription;

+ (id)contextNodeWithCallSite:(KWCallSite *)aCallSite parentContext:(KWContextNode *)contextNode description:(NSString *)aDescription;

#pragma mark -
#pragma mark  Getting Call Sites

@property (nonatomic, strong, readonly) KWCallSite *callSite;

#pragma mark -
#pragma mark Getting Descriptions

@property (nonatomic, copy, readonly) NSString *description;

#pragma mark -
#pragma mark Managing Nodes

@property (nonatomic, strong) KWRegisterMatchersNode *registerMatchersNode;
@property (nonatomic, strong) KWBeforeAllNode *beforeAllNode;
@property (nonatomic, strong) KWAfterAllNode *afterAllNode;
@property (nonatomic, strong) KWBeforeEachNode *beforeEachNode;
@property (nonatomic, strong) KWAfterEachNode *afterEachNode;
@property (nonatomic, weak, readonly) KWContextNode *parentContext;
@property (nonatomic, strong, readonly) NSArray *nodes;

@property (nonatomic, assign) int performedExampleCount;

- (void)addContextNode:(KWContextNode *)aNode;
- (void)addItNode:(KWItNode *)aNode;
- (void)addPendingNode:(KWPendingNode *)aNode;

- (void)performExample:(KWExample *)example withBlock:(void (^)(void))exampleBlock;

#pragma mark -
#pragma mark Accepting Visitors

- (void)acceptExampleNodeVisitor:(id<KWExampleNodeVisitor>)aVisitor;

@end
