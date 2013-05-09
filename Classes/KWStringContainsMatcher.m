//
//  StringContainsMatcher.m
//  Kiwi
//
//  Created by Stewart Gleadow on 7/06/12.
//  Copyright (c) 2012 Allen Ding. All rights reserved.
//

#import "KWStringContainsMatcher.h"

@interface KWStringContainsMatcher(){}
@property (nonatomic, copy) NSString *substring;
@end

@implementation KWStringContainsMatcher

+ (id)matcherWithSubstring:(NSString *)aSubstring;
{
  return [[[self alloc] initWithSubstring:aSubstring] autorelease];
}

- (id)initWithSubstring:(NSString *)aSubstring;
{
  if ((self = [super init])) {
    _substring = [aSubstring copy];
  }
  return self;
}

- (void)dealloc
{
  [_substring release];
  [super dealloc];
}

- (BOOL)matches:(id)item
{
  if (![item respondsToSelector:@selector(rangeOfString:)])
    return NO;
  
  return [item rangeOfString:self.substring].location != NSNotFound;
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"a string with substring '%@'", self.substring];
}

@end
