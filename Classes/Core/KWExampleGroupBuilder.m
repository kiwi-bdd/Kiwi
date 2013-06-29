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
#import "KWCallSite.h"
#import "KWContextNode.h"
#import "KWExample.h"
#import "KWExampleSuite.h"
#import "KWItNode.h"
#import "KWPendingNode.h"
#import "KWRegisterMatchersNode.h"
#import "KWSymbolicator.h"

@interface KWExampleGroupBuilder()

#pragma mark - Building Example Groups

@property (nonatomic, strong, readwrite) KWExampleSuite *exampleSuite;
@property (nonatomic, readonly) NSMutableArray *contextNodeStack;

@property (nonatomic, strong) NSMutableSet *suites;

@property (nonatomic, assign) BOOL focusedContextNode;
@property (nonatomic, assign) BOOL focusedItNode;

@end

@implementation KWExampleGroupBuilder


#pragma mark - Initializing


- (id)init {
    if ((self = [super init])) {
        _contextNodeStack = [[NSMutableArray alloc] init];
        _suites = [[NSMutableSet alloc] init];
        [self focusWithURI:[[[NSProcessInfo processInfo] environment] objectForKey:@"KW_SPEC"]];
    }
    return self;
}


+ (id)sharedExampleGroupBuilder {
    static KWExampleGroupBuilder *sharedExampleGroupBuilder = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedExampleGroupBuilder = [self new];
    });

    return sharedExampleGroupBuilder;
}

#pragma mark - Focus

- (void)focusWithURI:(NSString *)nodeUrl {
    NSArray *focusInfo = [nodeUrl componentsSeparatedByString:@":"];
    if (!focusInfo || focusInfo.count != 2)
        return;
    self.focusedCallSite = [KWCallSite callSiteWithFilename:focusInfo[0] lineNumber:[focusInfo[1] intValue]];
}

- (void)setFocusedCallSite:(KWCallSite *)aFocusedCallSite {
    _focusedCallSite = aFocusedCallSite;
    self.focusedItNode = NO;
    self.focusedContextNode = NO;
}

- (BOOL)isFocused {
    return !!self.focusedCallSite;
}

- (BOOL)foundFocus {
    return self.focusedContextNode || self.focusedItNode;
}

#pragma mark - Building Example Groups

- (BOOL)isBuildingExampleGroup {
    return [self.contextNodeStack count] > 0;
}

- (KWExampleSuite *)buildExampleGroups:(void (^)(void))buildingBlock
{
    KWContextNode *rootNode = [KWContextNode contextNodeWithCallSite:nil parentContext:nil description:nil];

    self.exampleSuite = [[KWExampleSuite alloc] initWithRootNode:rootNode];
    
    [self.suites addObject:self.exampleSuite];

    [self.contextNodeStack addObject:rootNode];
    buildingBlock();
    [self.contextNodeStack removeAllObjects];
    
    return self.exampleSuite;
}

- (void)pushContextNodeWithCallSite:(KWCallSite *)aCallSite description:(NSString *)aDescription {

    KWContextNode *contextNode = [self.contextNodeStack lastObject];
    KWContextNode *node = [KWContextNode contextNodeWithCallSite:aCallSite parentContext:contextNode description:aDescription];

    if (self.isFocused)
        node.isFocused = [self shouldFocusContextNodeWithCallSite:aCallSite parentNode:contextNode];

    [contextNode addContextNode:node];
    [self.contextNodeStack addObject:node];
}

- (BOOL)shouldFocusContextNodeWithCallSite:(KWCallSite *)aCallSite parentNode:(KWContextNode *)parentNode {
    if (parentNode.isFocused)
        return YES;

    if ([aCallSite isEqualToCallSite:self.focusedCallSite]) {
        self.focusedContextNode = YES;
        return YES;
    }
    return NO;
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

- (void)setBeforeAllNodeWithCallSite:(KWCallSite *)aCallSite block:(void (^)(void))block {
    if ([self.contextNodeStack count] == 0)
        [NSException raise:@"KWExampleGroupBuilderException" format:@"an example group has not been started"];

    KWContextNode *contextNode = [self.contextNodeStack lastObject];
    KWBeforeAllNode *beforeAllNode = [KWBeforeAllNode beforeAllNodeWithCallSite:aCallSite block:block];
    [contextNode setBeforeAllNode:beforeAllNode];
}

- (void)setAfterAllNodeWithCallSite:(KWCallSite *)aCallSite block:(void (^)(void))block {
    if ([self.contextNodeStack count] == 0)
        [NSException raise:@"KWExampleGroupBuilderException" format:@"an example group has not been started"];

    KWContextNode *contextNode = [self.contextNodeStack lastObject];
    KWAfterAllNode *afterAllNode = [KWAfterAllNode afterAllNodeWithCallSite:aCallSite block:block];
    [contextNode setAfterAllNode:afterAllNode];
}

- (void)setBeforeEachNodeWithCallSite:(KWCallSite *)aCallSite block:(void (^)(void))block {
    if ([self.contextNodeStack count] == 0)
        [NSException raise:@"KWExampleGroupBuilderException" format:@"an example group has not been started"];

    KWContextNode *contextNode = [self.contextNodeStack lastObject];
    KWBeforeEachNode *beforeEachNode = [KWBeforeEachNode beforeEachNodeWithCallSite:aCallSite block:block];
    [contextNode setBeforeEachNode:beforeEachNode];
}

- (void)setAfterEachNodeWithCallSite:(KWCallSite *)aCallSite block:(void (^)(void))block {
    if ([self.contextNodeStack count] == 0)
        [NSException raise:@"KWExampleGroupBuilderException" format:@"an example group has not been started"];

    KWContextNode *contextNode = [self.contextNodeStack lastObject];
    KWAfterEachNode *afterEachNode = [KWAfterEachNode afterEachNodeWithCallSite:aCallSite block:block];
    [contextNode setAfterEachNode:afterEachNode];
}

- (void)addItNodeWithCallSite:(KWCallSite *)aCallSite description:(NSString *)aDescription block:(void (^)(void))block {
    if ([self.contextNodeStack count] == 0)
        [NSException raise:@"KWExampleGroupBuilderException" format:@"an example group has not been started"];

    KWContextNode *contextNode = [self.contextNodeStack lastObject];

    if (self.isFocused && ![self shouldAddItNodeWithCallSite:aCallSite toContextNode:contextNode])
        return;

    KWItNode* itNode = [KWItNode itNodeWithCallSite:aCallSite description:aDescription context:contextNode block:block];
    [contextNode addItNode:itNode];
    
    KWExample *example = [[KWExample alloc] initWithExampleNode:itNode];
    [self.exampleSuite addExample:example];
}

- (BOOL)shouldAddItNodeWithCallSite:(KWCallSite *)aCallSite toContextNode:(KWContextNode *)contextNode {
    if (contextNode.isFocused)
        return YES;

    if([aCallSite isEqualToCallSite:self.focusedCallSite]){
        self.focusedItNode = YES;
        return YES;
    }

    return NO;
}

- (void)addPendingNodeWithCallSite:(KWCallSite *)aCallSite description:(NSString *)aDescription {
    if ([self.contextNodeStack count] == 0)
        [NSException raise:@"KWExampleGroupBuilderException" format:@"an example group has not been started"];

    KWContextNode *contextNode = [self.contextNodeStack lastObject];
    KWPendingNode *pendingNode = [KWPendingNode pendingNodeWithCallSite:aCallSite context:contextNode description:aDescription];
    [contextNode addPendingNode:pendingNode];
    KWExample *example = [[KWExample alloc] initWithExampleNode:pendingNode];
    [self.exampleSuite addExample:example];
}

@end
