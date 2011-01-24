//
//  NSObject+KiwiAdditions.m
//  Kiwi
//
//  Created by Luke Redpath on 24/01/2011.
//  Copyright 2011 Allen Ding. All rights reserved.
//

#import "NSObject+KiwiAdditions.h"
#import "KWHCMatcher.h"

@implementation NSObject (KiwiAdditions)

- (BOOL)isEqualOrMatches:(id)object
{
  if ([self conformsToProtocol:@protocol(HCMatcher)]) {
    return [(id<HCMatcher>)self matches:object];
  }
  return [self isEqual:object];
}

@end
