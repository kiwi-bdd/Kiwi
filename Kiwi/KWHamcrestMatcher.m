//
//  KWHamcrestMatcher.m
//  Kiwi
//
//  Created by Luke Redpath on 24/01/2011.
//  Copyright 2011 Allen Ding. All rights reserved.
//

#import "KWHamcrestMatcher.h"
#import "KWHCMatcher.h"

@interface KWHamcrestMatcher ()

#pragma mark -
#pragma mark Properties

@property (nonatomic, retain) id<HCMatcher> hamcrestMatcher;

@end

@implementation KWHamcrestMatcher

@synthesize hamcrestMatcher;

- (void)dealloc
{
  [hamcrestMatcher release];
  [super dealloc];
}

#pragma mark -
#pragma mark Matching

- (BOOL)evaluate {
    return [self.hamcrestMatcher matches:self.subject];
}

- (NSString *)failureMessageForShould {
  return [NSString stringWithFormat:@"expected %@ to %@", subject, self];
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"match %@", [self.hamcrestMatcher description]];
}

#pragma mark -
#pragma mark Getting Matcher Strings

+ (NSArray *)matcherStrings {
  return [NSArray arrayWithObjects:@"match:", nil];
}

#pragma mark -
#pragma mark Configuring Matchers

- (void)match:(id<HCMatcher>)aMatcher;
{
    self.hamcrestMatcher = aMatcher;
}

@end
