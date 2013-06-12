//
//  KWBeNotNilMatcher.m
//  Kiwi
//
//  Created by Luke Redpath on 17/01/2011.
//  Copyright 2011 Allen Ding. All rights reserved.
//

#import "KWBeNonNilMatcher.h"
#import "KWExample.h"
#import "KWExampleGroupBuilder.h"
#import "KWFormatter.h"
#import "KWMatchVerifier.h"
#import "KWVerifying.h"

@implementation KWBeNonNilMatcher

#pragma mark -
#pragma mark Getting Matcher Strings

+ (NSArray *)matcherStrings {
  return @[@"beNonNil", @"beNonNil:"];
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
- (void)beNonNil:(BOOL)matcherHasSubject {}

+ (BOOL)verifyNilSubject {
    KWExample *currentExample = [[KWExampleGroupBuilder sharedExampleGroupBuilder] currentExample];
    id<KWVerifying> verifier = currentExample.unassignedVerifier;
    if (verifier && ![verifier subject] && [verifier isKindOfClass:[KWMatchVerifier class]]) {
        KWMatchVerifier *matchVerifier = (KWMatchVerifier *)verifier;
        [matchVerifier performSelector:@selector(beNonNil)];
        currentExample.unassignedVerifier = nil;
        return NO;
    }
    return YES;
}

@end
