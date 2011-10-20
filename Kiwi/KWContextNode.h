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

@interface KWContextNode : NSObject<KWExampleNode> {
@private
    KWContextNode *parentContext;
    KWCallSite *callSite;
    NSString *description;
    KWRegisterMatchersNode *registerMatchersNode;
    KWBeforeAllNode *beforeAllNode;
    KWAfterAllNode *afterAllNode;
    KWBeforeEachNode *beforeEachNode;
    KWAfterEachNode *afterEachNode;
    NSMutableArray *nodes;
    BOOL performedExampleCount;
}

#pragma mark -
#pragma mark Initializing

- (id)initWithCallSite:(KWCallSite *)aCallSite parentContext:(KWContextNode *)node description:(NSString *)aDescription;

+ (id)contextNodeWithCallSite:(KWCallSite *)aCallSite parentContext:(KWContextNode *)contextNode description:(NSString *)aDescription;

#pragma mark -
#pragma mark  Getting Call Sites

@property (nonatomic, readonly) KWCallSite *callSite;

#pragma mark -
#pragma mark Getting Descriptions

@property (nonatomic, readonly) NSString *description;

#pragma mark -
#pragma mark Managing Nodes

@property (nonatomic, readwrite, retain) KWRegisterMatchersNode *registerMatchersNode;
@property (nonatomic, readwrite, retain) KWBeforeAllNode *beforeAllNode;
@property (nonatomic, readwrite, retain) KWAfterAllNode *afterAllNode;
@property (nonatomic, readwrite, retain) KWBeforeEachNode *beforeEachNode;
@property (nonatomic, readwrite, retain) KWAfterEachNode *afterEachNode;
@property (nonatomic, readonly) KWContextNode *parentContext;
@property (nonatomic, readonly) NSArray *nodes;

- (void)addContextNode:(KWContextNode *)aNode;
- (void)addItNode:(KWItNode *)aNode;
- (void)addPendingNode:(KWPendingNode *)aNode;

- (void)performExample:(KWExample *)example withBlock:(void (^)(void))exampleBlock;

#pragma mark -
#pragma mark Accepting Visitors

- (void)acceptExampleNodeVisitor:(id<KWExampleNodeVisitor>)aVisitor;

@end
