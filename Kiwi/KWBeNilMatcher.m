//
//  KWBeNilMatcher.m
//  iOSFalconCore
//
//  Created by Luke Redpath on 14/01/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import "KWBeNilMatcher.h"
#import "KWFormatter.h"

@implementation KWBeNilMatcher

#pragma mark -
#pragma mark Getting Matcher Strings

+ (NSArray *)matcherStrings {
  return [NSArray arrayWithObjects:@"beNil", nil];
}

#pragma mark -
#pragma mark Matching

- (BOOL)evaluate {
  return (BOOL)(self.subject == nil);
}

#pragma mark -
#pragma mark Getting Failure Messages

- (NSString *)failureMessageForShould {
  return [NSString stringWithFormat:@"expected subject to be nil, got %@",
          [KWFormatter formatObject:self.subject]];
}

- (NSString *)failureMessageForShouldNot {
  return [NSString stringWithFormat:@"expected %@ not to be nil",
          [KWFormatter formatObject:self.subject]];
}

- (void)beNil {}

@end
