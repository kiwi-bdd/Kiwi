//
//  StringPrefixMatcher.m
//  Kiwi
//
//  Created by Luke Redpath on 17/01/2011.
//  Copyright 2011 Allen Ding. All rights reserved.
//

#import "KWStringPrefixMatcher.h"


@implementation KWStringPrefixMatcher

+ (id)matcherWithPrefix:(NSString *)aPrefix;
{
  return [[[self alloc] initWithPrefix:aPrefix] autorelease];
}

- (id)initWithPrefix:(NSString *)aPrefix;
{
  if ((self = [super init])) {
    prefix = [aPrefix copy];
  }
  return self;
}

- (void)dealloc
{
  [prefix release];
  [super dealloc];
}

- (BOOL)matches:(id)item
{
  if (![item respondsToSelector:@selector(hasPrefix:)])
    return NO;

  return [item hasPrefix:prefix];
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"a string with prefix '%@'", prefix];
}

@end
