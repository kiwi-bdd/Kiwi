//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWItNode.h"
#import "KWExampleNodeVisitor.h"
#import "KWExampleGroup.h"
#import "KWVerifying.h"

@implementation KWItNode

@synthesize exampleGroup;

#pragma mark -
#pragma mark Initializing

+ (id)itNodeWithCallSite:(KWCallSite *)aCallSite description:(NSString *)aDescription block:(KWVoidBlock)aBlock {
    return [[[self alloc] initWithCallSite:aCallSite description:aDescription block:aBlock] autorelease];
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
    description = [self.exampleGroup generateDescriptionForAnonymousItNode];
  }
  return description;
}

@end
