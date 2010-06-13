//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWExampleGroupBuilder.h"
#import "KWAfterAllNode.h"
#import "KWAfterEachNode.h"
#import "KWBeforeAllNode.h"
#import "KWBeforeEachNode.h"
#import "KWContextNode.h"
#import "KWItNode.h"
#import "KWPendingNode.h"
#import "KWRegisterMatchersNode.h"

#if KW_BLOCKS_ENABLED

@interface KWExampleGroupBuilder()

#pragma mark -
#pragma mark Building Example Groups

@property (nonatomic, readonly) NSMutableArray *contextNodeStack;

@end

@implementation KWExampleGroupBuilder

#pragma mark -
#pragma mark Initializing

static KWExampleGroupBuilder *sharedExampleGroupBuilder = nil;

- (id)init {
    if ((self = [super init])) {
        contextNodeStack = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc {
    [contextNodeStack release];
    [super dealloc];
}

+ (id)sharedExampleGroupBuilder {
    if (sharedExampleGroupBuilder == nil) {
        sharedExampleGroupBuilder = [[super allocWithZone:nil] init];
    }
    
    return sharedExampleGroupBuilder;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [[self sharedExampleGroupBuilder] retain];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return NSUIntegerMax;
}

- (void)release {
}

- (id)autorelease {
    return self;
}

#pragma mark -
#pragma mark Building Example Groups

@synthesize contextNodeStack;

- (BOOL)isBuildingExampleGroup {
    return [self.contextNodeStack count] > 0;
}

- (void)startExampleGroups {
    if (self.isBuildingExampleGroup)
        [NSException raise:@"KWExampleGroupBuilderException" format:@"an example group has already been started"];
    
    KWContextNode *exampleGroup = [KWContextNode contextNodeWithCallSite:nil description:nil];
    [self.contextNodeStack addObject:exampleGroup];
}

- (id)endExampleGroups {
    if (!self.isBuildingExampleGroup)
        [NSException raise:@"KWExampleGroupBuilderException" format:@"an example group has not been started"];
    
    if ([self.contextNodeStack count] > 1)
        [NSException raise:@"KWExampleGroupBuilderException" format:@"cannot end example group with open contexts"];
    
    KWContextNode *rootContextNode = [[[self.contextNodeStack lastObject] retain] autorelease];
    [self.contextNodeStack removeAllObjects];
    return rootContextNode;
}

- (void)pushContextNodeWithCallSite:(KWCallSite *)aCallSite description:(NSString *)aDescription {
    KWContextNode *contextNode = [self.contextNodeStack lastObject];
    KWContextNode *node = [KWContextNode contextNodeWithCallSite:aCallSite description:aDescription];
    [contextNode addContextNode:node];
    [self.contextNodeStack addObject:node];
}

- (void)popContextNode {
    if ([self.contextNodeStack count] == 1)
        [NSException raise:@"KWExampleGroupBuilderException" format:@"there is no open context to pop"];
    
    [self.contextNodeStack removeLastObject];
}

- (void)setRegisterMatchersNodeWithCallSite:(KWCallSite *)aCallSite namespacePrefix:(NSString *)aNamespacePrefix {
    if ([self.contextNodeStack count] == 0)
        [NSException raise:@"KWExampleGroupBuilderException" format:@"an example group has not been started"];
    
    KWContextNode *contextNode = [self.contextNodeStack lastObject];
    KWRegisterMatchersNode *registerMatchersNode = [KWRegisterMatchersNode registerMatchersNodeWithCallSite:aCallSite namespacePrefix:aNamespacePrefix];
    [contextNode setRegisterMatchersNode:registerMatchersNode];
}

- (void)setBeforeAllNodeWithCallSite:(KWCallSite *)aCallSite block:(KWVoidBlock)aBlock {
    if ([self.contextNodeStack count] == 0)
        [NSException raise:@"KWExampleGroupBuilderException" format:@"an example group has not been started"];
    
    KWContextNode *contextNode = [self.contextNodeStack lastObject];
    KWBeforeAllNode *beforeAllNode = [KWBeforeAllNode beforeAllNodeWithCallSite:aCallSite block:aBlock];
    [contextNode setBeforeAllNode:beforeAllNode];
}

- (void)setAfterAllNodeWithCallSite:(KWCallSite *)aCallSite block:(KWVoidBlock)aBlock {
    if ([self.contextNodeStack count] == 0)
        [NSException raise:@"KWExampleGroupBuilderException" format:@"an example group has not been started"];
    
    KWContextNode *contextNode = [self.contextNodeStack lastObject];
    KWAfterAllNode *afterAllNode = [KWAfterAllNode afterAllNodeWithCallSite:aCallSite block:aBlock];
    [contextNode setAfterAllNode:afterAllNode];
}

- (void)setBeforeEachNodeWithCallSite:(KWCallSite *)aCallSite block:(KWVoidBlock)aBlock {
    if ([self.contextNodeStack count] == 0)
        [NSException raise:@"KWExampleGroupBuilderException" format:@"an example group has not been started"];
    
    KWContextNode *contextNode = [self.contextNodeStack lastObject];
    KWBeforeEachNode *beforeEachNode = [KWBeforeEachNode beforeEachNodeWithCallSite:aCallSite block:aBlock];
    [contextNode setBeforeEachNode:beforeEachNode];
}

- (void)setAfterEachNodeWithCallSite:(KWCallSite *)aCallSite block:(KWVoidBlock)aBlock {
    if ([self.contextNodeStack count] == 0)
        [NSException raise:@"KWExampleGroupBuilderException" format:@"an example group has not been started"];

    KWContextNode *contextNode = [self.contextNodeStack lastObject];
    KWAfterEachNode *afterEachNode = [KWAfterEachNode afterEachNodeWithCallSite:aCallSite block:aBlock];
    [contextNode setAfterEachNode:afterEachNode];
}

- (void)addItNodeWithCallSite:(KWCallSite *)aCallSite description:(NSString *)aDescription block:(KWVoidBlock)aBlock {
    if ([self.contextNodeStack count] == 0)
        [NSException raise:@"KWExampleGroupBuilderException" format:@"an example group has not been started"];
    
    KWContextNode *contextNode = [self.contextNodeStack lastObject];
    KWItNode* itNode = [KWItNode itNodeWithCallSite:aCallSite description:aDescription block:aBlock];
    [contextNode addItNode:itNode];
}

- (void)addPendingNodeWithCallSite:(KWCallSite *)aCallSite description:(NSString *)aDescription {
    if ([self.contextNodeStack count] == 0)
        [NSException raise:@"KWExampleGroupBuilderException" format:@"an example group has not been started"];
    
    KWContextNode *contextNode = [self.contextNodeStack lastObject];
    KWPendingNode *pendingNode = [KWPendingNode pendingNodeWithCallSite:aCallSite description:aDescription];
    [contextNode addPendingNode:pendingNode];
}

@end

#endif // #if KW_BLOCKS_ENABLED
