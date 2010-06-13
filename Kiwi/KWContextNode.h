//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"
#import "KWExampleNode.h"

#if KW_BLOCKS_ENABLED

@class KWAfterAllNode;
@class KWAfterEachNode;
@class KWBeforeAllNode;
@class KWBeforeEachNode;
@class KWCallSite;
@class KWItNode;
@class KWPendingNode;
@class KWRegisterMatchersNode;

@interface KWContextNode : NSObject<KWExampleNode> {
@private
    KWCallSite *callSite;
    NSString *description;
    KWRegisterMatchersNode *registerMatchersNode;
    KWBeforeAllNode *beforeAllNode;
    KWAfterAllNode *afterAllNode;
    KWBeforeEachNode *beforeEachNode;
    KWAfterEachNode *afterEachNode;
    NSMutableArray *nodes;
}

#pragma mark -
#pragma mark Initializing

- (id)initWithCallSite:(KWCallSite *)aCallSite description:(NSString *)aDescription;

+ (id)contextNodeWithCallSite:(KWCallSite *)aCallSite description:(NSString *)aDescription;

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
@property (nonatomic, readonly) NSArray *nodes;

- (void)addContextNode:(KWContextNode *)aNode;
- (void)addItNode:(KWItNode *)aNode;
- (void)addPendingNode:(KWPendingNode *)aNode;

#pragma mark -
#pragma mark Accepting Visitors

- (void)acceptExampleNodeVisitor:(id<KWExampleNodeVisitor>)aVisitor;

@end

#endif // #if KW_BLOCKS_ENABLED
