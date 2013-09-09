//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWAfterAllNode.h"
#import "KWAfterEachNode.h"
#import "KWBeforeAllNode.h"
#import "KWBeforeEachNode.h"
#import "KWLetNode.h"
#import "KWCallSite.h"
#import "KWContextNode.h"
#import "KWExampleNodeVisitor.h"
#import "KWExample.h"
#import "KWFailure.h"
#import "KWRegisterMatchersNode.h"
#import "KWSymbolicator.h"

@interface KWContextNode()

@property (nonatomic, assign) NSUInteger performedExampleCount;

@property (nonatomic, readonly) NSMutableArray *letNodes;
@property (nonatomic, readonly) NSMutableDictionary *declaredLetNodes;

@end

@implementation KWContextNode

#pragma mark - Initializing

- (id)initWithCallSite:(KWCallSite *)aCallSite parentContext:(KWContextNode *)node description:(NSString *)aDescription {
    self = [super init];
    if (self) {
        _parentContext = node;
        _callSite = aCallSite;
        _description = [aDescription copy];
        _nodes = [[NSMutableArray alloc] init];
        _letNodes = [[NSMutableArray alloc] init];
        _declaredLetNodes = [[NSMutableDictionary alloc] init];
        _performedExampleCount = 0;
    }

    return self;
}

+ (id)contextNodeWithCallSite:(KWCallSite *)aCallSite parentContext:(KWContextNode *)contextNode description:(NSString *)aDescription {
    return [[self alloc] initWithCallSite:aCallSite parentContext:contextNode description:aDescription];
}

- (void)addContextNode:(KWContextNode *)aNode {
    [(NSMutableArray *)self.nodes addObject:aNode];
}

- (void)setRegisterMatchersNode:(KWRegisterMatchersNode *)aNode {
    if (self.registerMatchersNode != nil)
        [NSException raise:@"KWContextNodeException" format:@"a register matchers node already exists"];

    _registerMatchersNode = aNode;
}

- (void)setBeforeEachNode:(KWBeforeEachNode *)aNode {
    if (self.beforeEachNode != nil)
        [NSException raise:@"KWContextNodeException" format:@"a before each node already exists"];

    _beforeEachNode = aNode;
}

- (void)setAfterEachNode:(KWAfterEachNode *)aNode {
    if (self.afterEachNode != nil)
        [NSException raise:@"KWContextNodeException" format:@"an after each node already exists"];

    _afterEachNode = aNode;
}

- (void)addLetNode:(KWLetNode *)aNode
{
    if (self.parentContext) {
        [self.parentContext addLetNode:aNode];
    }
    else {
        [self registerLetNode:aNode];
    }
}

- (void)registerLetNode:(KWLetNode *)aNode
{
    [self.letNodes addObject:aNode];

    NSMutableArray *declaredLetNodes = self.declaredLetNodes[aNode.symbolName];
    if (!declaredLetNodes) {
        declaredLetNodes = [[NSMutableArray alloc] init];
        self.declaredLetNodes[aNode.symbolName] = declaredLetNodes;
    }

    [declaredLetNodes addObject:aNode];
}

- (void)addItNode:(KWItNode *)aNode {
    [(NSMutableArray *)self.nodes addObject:aNode];
}

- (void)addPendingNode:(KWPendingNode *)aNode {
    [(NSMutableArray *)self.nodes addObject:aNode];
}

- (void)performExample:(KWExample *)example withBlock:(void (^)(void))exampleBlock
{
    void (^innerExampleBlock)(void) = [exampleBlock copy];
    
    void (^outerExampleBlock)(void) = ^{
        @try {
            [self.registerMatchersNode acceptExampleNodeVisitor:example];
            
            if (self.performedExampleCount == 0) {
                [self.beforeAllNode acceptExampleNodeVisitor:example];
            }
            
            [self.beforeEachNode acceptExampleNodeVisitor:example];
            
            [self evaluateLetNodes];
            
            innerExampleBlock();
            
            [self.afterEachNode acceptExampleNodeVisitor:example];

            if ([example isLastInContext:self]) {
                [self.afterAllNode acceptExampleNodeVisitor:example];
            }
            
        } @catch (NSException *exception) {
            KWFailure *failure = [KWFailure failureWithCallSite:self.callSite format:@"%@ \"%@\" raised", [exception name], [exception reason]];
            [example reportFailure:failure];
        }
        
        self.performedExampleCount++;
    };
    if (self.parentContext == nil) {
        outerExampleBlock();
    }
    else {
        [self.parentContext performExample:example withBlock:outerExampleBlock];
    }
}

- (void)evaluateLetNodes {
    if (self.parentContext) {
        [self.parentContext evaluateLetNodes];
    }
    else {
        NSDictionary *evaluatedSymbols = [self evaluatedSymbolsForDeclaredLetNodes:self.declaredLetNodes];
        [self propagateEvaluatedLetNodesToObjectRefsForSymbols:evaluatedSymbols];
    }
}

- (NSDictionary *)evaluatedSymbolsForDeclaredLetNodes:(NSDictionary *)declaredLetNodes {
    NSMutableDictionary *evaluatedSymbols = [[NSMutableDictionary alloc] init];
    for (KWLetNode *letNode in self.letNodes) {
        NSArray *declaredLetNodes = self.declaredLetNodes[letNode.symbolName];
        KWLetNode *deepestDeclaredLetNode = [declaredLetNodes lastObject];
        id result = [deepestDeclaredLetNode evaluate];
        [evaluatedSymbols setObject:result forKey:letNode.symbolName];
    }
    return evaluatedSymbols;
}

- (void)propagateEvaluatedLetNodesToObjectRefsForSymbols:(NSDictionary *)evaluatedSymbols {
    for (id symbol in evaluatedSymbols) {
        NSArray *declaredLetNodes = self.declaredLetNodes[symbol];
        for (KWLetNode *declaredLetNode in declaredLetNodes) {
            *declaredLetNode.objectRef = evaluatedSymbols[symbol];
        }
    }
}

#pragma mark - Accepting Visitors

- (void)acceptExampleNodeVisitor:(id<KWExampleNodeVisitor>)aVisitor {
    [aVisitor visitContextNode:self];
}

@end
