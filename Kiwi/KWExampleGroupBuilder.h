//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"
#import "KWBlock.h"

@class KWCallSite;
@class KWExampleGroup;

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
@property (nonatomic, retain, readonly) NSMutableArray *exampleGroups;
@property (nonatomic, retain) KWExampleGroup *currentExampleGroup;

- (NSArray *)buildExampleGroups:(void (^)(void))buildingBlock;
- (KWExampleGroup *)currentExampleGroup;

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
