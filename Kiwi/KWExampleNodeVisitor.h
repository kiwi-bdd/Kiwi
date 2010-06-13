//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"

#if KW_BLOCKS_ENABLED

@class KWAfterAllNode;
@class KWAfterEachNode;
@class KWBeforeAllNode;
@class KWBeforeEachNode;
@class KWContextNode;
@class KWItNode;
@class KWPendingNode;
@class KWRegisterMatchersNode;

@protocol KWExampleNodeVisitor<NSObject>

#pragma mark -
#pragma mark Visiting Nodes

- (void)visitContextNode:(KWContextNode *)aNode;
- (void)visitRegisterMatchersNode:(KWRegisterMatchersNode *)aNode;
- (void)visitBeforeAllNode:(KWBeforeAllNode *)aNode;
- (void)visitAfterAllNode:(KWAfterAllNode *)aNode;
- (void)visitBeforeEachNode:(KWBeforeEachNode *)aNode;
- (void)visitAfterEachNode:(KWAfterEachNode *)aNode;
- (void)visitItNode:(KWItNode *)aNode;
- (void)visitPendingNode:(KWPendingNode *)aNode;

@end

#endif // #if KW_BLOCKS_ENABLED
