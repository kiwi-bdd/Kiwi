//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"
#import "KWBlock.h"

#if KW_BLOCKS_ENABLED

@class KWCallSite;

@interface KWExampleGroupBuilder : NSObject {
@private
    NSMutableArray *contextNodeStack;
}

#pragma mark -
#pragma mark Initializing

+ (id)sharedExampleGroupBuilder;

#pragma mark -
#pragma mark Building Example Groups

@property (nonatomic, readonly) BOOL isBuildingExampleGroup;

- (void)startExampleGroups;
- (id)endExampleGroups;

- (void)pushContextNodeWithCallSite:(KWCallSite *)aCallSite description:(NSString *)aDescription;
- (void)popContextNode;
- (void)setRegisterMatchersNodeWithCallSite:(KWCallSite *)aCallSite namespacePrefix:(NSString *)aNamespacePrefix;
- (void)setBeforeAllNodeWithCallSite:(KWCallSite *)aCallSite block:(KWVoidBlock)aBlock;
- (void)setAfterAllNodeWithCallSite:(KWCallSite *)aCallSite block:(KWVoidBlock)aBlock;
- (void)setBeforeEachNodeWithCallSite:(KWCallSite *)aCallSite block:(KWVoidBlock)aBlock;
- (void)setAfterEachNodeWithCallSite:(KWCallSite *)aCallSite block:(KWVoidBlock)aBlock;
- (void)addItNodeWithCallSite:(KWCallSite *)aCallSite description:(NSString *)aDescription block:(KWVoidBlock)aBlock;
- (void)addPendingNodeWithCallSite:(KWCallSite *)aCallSite description:(NSString *)aDescription;

@end

#endif // #if KW_BLOCKS_ENABLED
