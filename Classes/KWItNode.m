//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWItNode.h"
#import "KWExampleNodeVisitor.h"
#import "KWExample.h"
#import "KWVerifying.h"
#import "KWContextNode.h"

@interface KWItNode ()

@property (nonatomic, retain, readwrite) KWContextNode *context;

@end

@implementation KWItNode

@synthesize context = _context;
@synthesize example;

#pragma mark -
#pragma mark Initializing

+ (id)itNodeWithCallSite:(KWCallSite *)aCallSite 
             description:(NSString *)aDescription 
                 context:(KWContextNode *)context 
                   block:(KWVoidBlock)aBlock;
{
    KWItNode *itNode = [[self alloc] initWithCallSite:aCallSite description:aDescription block:aBlock];
    itNode.context = context;
    return [itNode autorelease];
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
  
  KWContextNode *currentContext = _context;
  
  while (currentContext) {
    [contextStack addObject:currentContext];
    currentContext = currentContext.parentContext;
  }
  return contextStack;
}

@end
