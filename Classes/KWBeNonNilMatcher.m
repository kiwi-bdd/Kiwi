//
//  KWBeNotNilMatcher.m
//  Kiwi
//
//  Created by Luke Redpath on 17/01/2011.
//  Copyright 2011 Allen Ding. All rights reserved.
//

#import "KWBeNonNilMatcher.h"
#import "KWFormatter.h"

@implementation KWBeNonNilMatcher

#pragma mark -
#pragma mark Getting Matcher Strings

+ (NSArray *)matcherStrings {
  return @[@"beNonNil"];
}

#pragma mark -
#pragma mark Matching

- (BOOL)evaluate {
  return (BOOL)(self.subject != nil);
}

#pragma mark -
#pragma mark Getting Failure Messages

- (NSString *)failureMessageForShould {
  return [NSString stringWithFormat:@"expected subject to be non-nil, got %@",
          [KWFormatter formatObject:self.subject]];
}

- (NSString *)failureMessageForShouldNot {
  return [NSString stringWithFormat:@"expected %@ not to be non-nil",
          [KWFormatter formatObject:self.subject]];
}

- (NSString *)description
{
  return @"be non-nil";
}

- (void)beNonNil {}

@end
