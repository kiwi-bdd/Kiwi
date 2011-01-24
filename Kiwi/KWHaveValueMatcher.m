//
//  KWHaveValueMatcher.m
//  Kiwi
//
//  Created by Luke Redpath on 24/01/2011.
//  Copyright 2011 Allen Ding. All rights reserved.
//

#import "KWHaveValueMatcher.h"
#import "KWHamrestMatchingAdditions.h"
#import "KWHCMatcher.h"

@interface KWHaveValueMatcher()

#pragma mark -
#pragma mark Properties

@property (nonatomic, retain) NSString *expectedKey;
@property (nonatomic, retain) NSString *expectedKeyPath;
@property (nonatomic, retain) id expectedValue;

- (id)subjectValue;

@end

@implementation KWHaveValueMatcher

@synthesize expectedKey, expectedKeyPath, expectedValue;

- (void)dealloc
{
  [expectedKeyPath release];
  [expectedKey release];
  [expectedValue release];
  [super dealloc];
}

#pragma mark -
#pragma mark Getting Matcher Strings

+ (NSArray *)matcherStrings {
  return [NSArray arrayWithObjects:@"haveValue:forKey:", 
          @"haveValueForKey:",
          @"haveValue:forKeyPath:",
          @"haveValueForKeyPath:", nil];
}

#pragma mark -
#pragma mark Matching

- (BOOL)evaluate {
  BOOL matched = NO;
  
  @try {
    id value = [self subjectValue];
    
    if (value) {
      matched = YES;
      
      if (self.expectedValue) {
        matched = [self.expectedValue isEqualOrMatches:value];
      }
    }
  }
  @catch (NSException * e) {} // catch KVO non-existent key errors
  
  return matched;
}

- (NSString *)failureMessageForShould {
    if (self.expectedValue == nil) {
        return [NSString stringWithFormat:@"expected subject to have a value for key %@", self.expectedKey];  
    }
    return [NSString stringWithFormat:@"expected subject to have value %@ for key %@", self.expectedValue, self.expectedKey];
}

- (id)subjectValue;
{
  id value = nil;
  
  if (self.expectedKey) {
    value = [self.subject valueForKey:self.expectedKey];
  } else
  if (self.expectedKeyPath) {
    value = [self.subject valueForKeyPath:self.expectedKeyPath];
  }
  return value;
}

#pragma mark -
#pragma mark Configuring Matchers

- (void)haveValue:(id)value forKey:(NSString *)key;
{
    self.expectedKey = key;
    self.expectedValue = value;
}

- (void)haveValue:(id)value forKeyPath:(NSString *)key;
{
    self.expectedKeyPath = key;
    self.expectedValue = value;
}

- (void)haveValueForKey:(NSString *)key;
{
    self.expectedKey = key;
    self.expectedValue = nil;
}

- (void)haveValueForKeyPath:(NSString *)keyPath;
{
    self.expectedKeyPath = keyPath;
    self.expectedValue = nil;
}

@end
