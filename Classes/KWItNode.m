//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWContextNode.h"
#import "KWExample.h"
#import "KWExampleNodeVisitor.h"
#import "KWItNode.h"
#import "KWVerifying.h"

@interface KWItNode ()

@property (nonatomic, strong) KWContextNode *context;

@end

@implementation KWItNode

#pragma mark -
#pragma mark Initializing

+ (id)itNodeWithCallSite:(KWCallSite *)aCallSite 
             description:(NSString *)aDescription 
                 context:(KWContextNode *)context 
                   block:(KWVoidBlock)aBlock;
{
    KWItNode *itNode = [[self alloc] initWithCallSite:aCallSite description:aDescription block:aBlock];
    itNode.context = context;
    return itNode;
}

#pragma mark -
#pragma mark Accepting Visitors

- (void)acceptExampleNodeVisitor:(id<KWExampleNodeVisitor>)aVisitor {
    [aVisitor visitItNode:self];
}

#pragma mark -
#pragma mark Runtime Description support

- (NSString *)description
{
  NSString *description = [super description];
  if (description == nil) {
    description = [self.example generateDescriptionForAnonymousItNode];
  }
  return description;
}

#pragma mark -
#pragma mark - Accessing the context stack

- (NSArray *)contextStack
{
  NSMutableArray *contextStack = [NSMutableArray array];
  
  KWContextNode *currentContext = self.context;
  
  while (currentContext) {
    [contextStack addObject:currentContext];
    currentContext = currentContext.parentContext;
  }
  return contextStack;
}

@end
