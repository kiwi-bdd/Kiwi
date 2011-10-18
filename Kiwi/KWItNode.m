//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWItNode.h"
#import "KWExampleNodeVisitor.h"
#import "KWExample.h"
#import "KWVerifying.h"

@interface KWItNode ()

@property (nonatomic, retain, readwrite) KWContextNode *context;

@end

@implementation KWItNode

@synthesize context;
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

@end
