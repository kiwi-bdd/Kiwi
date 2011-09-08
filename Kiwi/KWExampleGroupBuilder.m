//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWExampleGroupBuilder.h"
#import "KWExampleGroup.h"
#import "KWAfterAllNode.h"
#import "KWAfterEachNode.h"
#import "KWBeforeAllNode.h"
#import "KWBeforeEachNode.h"
#import "KWContextNode.h"
#import "KWItNode.h"
#import "KWPendingNode.h"
#import "KWRegisterMatchersNode.h"

@interface KWExampleGroupBuilder()

#pragma mark -
#pragma mark Building Example Groups

@property (nonatomic, retain, readwrite) NSMutableArray *exampleGroups;
@property (nonatomic, readonly) NSMutableArray *contextNodeStack;

@end

@implementation KWExampleGroupBuilder

@synthesize exampleGroups;
@synthesize currentExampleGroup;

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
    [exampleGroups release];
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

- (oneway void)release {
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

- (NSArray *)buildExampleGroups:(void (^)(void))buildingBlock
{
    self.exampleGroups = [NSMutableArray array];
    
    KWContextNode *rootNode = [KWContextNode contextNodeWithCallSite:nil description:nil];

    [self.contextNodeStack addObject:rootNode];
    buildingBlock();
    [self.contextNodeStack removeAllObjects];
    
    NSArray *_exampleGroups = [self.exampleGroups copy];
    
    self.exampleGroups = nil;
    
    return [_exampleGroups autorelease];
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
    
    KWExampleGroup *exampleGroup = [[KWExampleGroup alloc] initWithExampleNode:itNode contextNodeStack:self.contextNodeStack];
    [self.exampleGroups addObject:exampleGroup];
    [exampleGroup release];
}

- (void)addPendingNodeWithCallSite:(KWCallSite *)aCallSite description:(NSString *)aDescription {
    if ([self.contextNodeStack count] == 0)
        [NSException raise:@"KWExampleGroupBuilderException" format:@"an example group has not been started"];

    KWContextNode *contextNode = [self.contextNodeStack lastObject];
    KWPendingNode *pendingNode = [KWPendingNode pendingNodeWithCallSite:aCallSite description:aDescription];
    [contextNode addPendingNode:pendingNode];
    
    KWExampleGroup *exampleGroup = [[KWExampleGroup alloc] initWithExampleNode:pendingNode contextNodeStack:self.contextNodeStack];
    [self.exampleGroups addObject:exampleGroup];
    [exampleGroup release];
}

@end
