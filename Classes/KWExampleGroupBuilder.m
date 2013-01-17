//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWExampleGroupBuilder.h"
#import "KWExample.h"
#import "KWAfterAllNode.h"
#import "KWAfterEachNode.h"
#import "KWBeforeAllNode.h"
#import "KWBeforeEachNode.h"
#import "KWContextNode.h"
#import "KWItNode.h"
#import "KWPendingNode.h"
#import "KWRegisterMatchersNode.h"
#import "KWExampleSuite.h"


@interface KWExampleGroupBuilder()

#pragma mark -
#pragma mark Building Example Groups

@property (nonatomic, retain, readwrite) KWExampleSuite *exampleSuite;
@property (nonatomic, readonly) NSMutableArray *contextNodeStack;

@end

@implementation KWExampleGroupBuilder

@synthesize exampleSuite;
@synthesize currentExample;

#pragma mark -
#pragma mark Initializing

static KWExampleGroupBuilder *sharedExampleGroupBuilder = nil;

- (id)init {
    if ((self = [super init])) {
        contextNodeStack = [[NSMutableArray alloc] init];
        suites = [[NSMutableSet alloc] init];
    }

    return self;
}

- (void)dealloc {
    [suites release];
    [exampleSuite release];
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

- (KWExampleSuite *)buildExampleGroups:(void (^)(void))buildingBlock
{
    KWContextNode *rootNode = [KWContextNode contextNodeWithCallSite:nil parentContext:nil description:nil];
   
    self.exampleSuite = [[[KWExampleSuite alloc] initWithRootNode:rootNode] autorelease];
    
    [suites addObject:self.exampleSuite];

    [self.contextNodeStack addObject:rootNode];
    buildingBlock();
    [self.contextNodeStack removeAllObjects];
    
    return self.exampleSuite;
}

- (void)pushContextNodeWithCallSite:(KWCallSite *)aCallSite description:(NSString *)aDescription {
    KWContextNode *contextNode = [self.contextNodeStack lastObject];
    KWContextNode *node = [KWContextNode contextNodeWithCallSite:aCallSite parentContext:contextNode description:aDescription];
    [contextNode addContextNode:node];
    [self.contextNodeStack addObject:node];
}

- (void)popContextNode {
    KWContextNode *contextNode = [self.contextNodeStack lastObject];
    
    [self.exampleSuite markLastExampleAsLastInContext:contextNode];
    
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
    KWItNode* itNode = [KWItNode itNodeWithCallSite:aCallSite description:aDescription context:contextNode block:aBlock];
    [contextNode addItNode:itNode];
    
    KWExample *example = [[KWExample alloc] initWithExampleNode:itNode];
    [self.exampleSuite addExample:example];
    [example release];
}

- (void)addPendingNodeWithCallSite:(KWCallSite *)aCallSite description:(NSString *)aDescription {
    if ([self.contextNodeStack count] == 0)
        [NSException raise:@"KWExampleGroupBuilderException" format:@"an example group has not been started"];

    KWContextNode *contextNode = [self.contextNodeStack lastObject];
    KWPendingNode *pendingNode = [KWPendingNode pendingNodeWithCallSite:aCallSite context:contextNode description:aDescription];
    [contextNode addPendingNode:pendingNode];
    
    KWExample *example = [[KWExample alloc] initWithExampleNode:pendingNode];
    [self.exampleSuite addExample:example];
    [example release];
}

@end
