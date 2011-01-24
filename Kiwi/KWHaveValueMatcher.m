//
//  KWHaveValueMatcher.m
//  Kiwi
//
//  Created by Luke Redpath on 24/01/2011.
//  Copyright 2011 Allen Ding. All rights reserved.
//

#import "KWHaveValueMatcher.h"
#import "NSObject+KiwiAdditions.h"

@interface KWHaveValueMatcher()

#pragma mark -
#pragma mark Properties

@property (nonatomic, retain) NSString *expectedKey;
@property (nonatomic, retain) id expectedValue;

@end

@implementation KWHaveValueMatcher

@synthesize expectedKey, expectedValue;

- (void)dealloc
{
  [expectedKey release];
  [expectedValue release];
  [super dealloc];
}

#pragma mark -
#pragma mark Getting Matcher Strings

+ (NSArray *)matcherStrings {
  return [NSArray arrayWithObjects:@"haveValue:forKey:", @"haveValueForKey:", nil];
}

#pragma mark -
#pragma mark Matching

- (BOOL)evaluate {
  BOOL matched = NO;
  
  @try {
    id value = [self.subject valueForKey:self.expectedKey];
    
    if (value) {
      matched = YES;
      
      if (self.expectedValue) {
        return [self.expectedValue isEqualOrMatches:value];
      }
    }
  }
  @catch (NSException * e) {} // catch KVO non-existent key errors
  
  return matched;
}

#pragma mark -
#pragma mark Configuring Matchers

- (void)haveValue:(id)value forKey:(NSString *)key;
{
    self.expectedKey = key;
    self.expectedValue = value;
}

- (void)haveValueForKey:(NSString *)key;
{
    self.expectedKey = key;
    self.expectedValue = nil;
}

@end
