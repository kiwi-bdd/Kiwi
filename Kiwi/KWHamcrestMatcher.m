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

@property (nonatomic, retain) id<HCMatcher> matcher;

@end

@implementation KWHamcrestMatcher

@synthesize matcher;

- (void)dealloc
{
  [matcher release];
  [super dealloc];
}

#pragma mark -
#pragma mark Matching

- (BOOL)evaluate {
    return [self.matcher matches:self.subject];
}

- (NSString *)failureMessageForShould {
  return [NSString stringWithFormat:@"expected subject to match %@", self.matcher];
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
    self.matcher = aMatcher;
}

@end
