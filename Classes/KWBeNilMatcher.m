//
//  KWBeNilMatcher.m
//  iOSFalconCore
//
//  Created by Luke Redpath on 14/01/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import "KWBeNilMatcher.h"
#import "KWExample.h"
#import "KWFormatter.h"
#import "KWExampleGroupBuilder.h"
#import "KWMatchVerifier.h"
#import "KWVerifying.h"

@implementation KWBeNilMatcher

#pragma mark -
#pragma mark Getting Matcher Strings

+ (NSArray *)matcherStrings {
  return @[@"beNil", @"beNil:"];
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

- (BOOL)shouldBeEvaluatedAtEndOfExample {
    return YES;
}

- (NSString *)description
{
    return @"be nil";
}

- (void)beNil {}
- (void)beNil:(BOOL)matcherHasSubject {}

+ (BOOL)verifyNilSubject {
    KWExample *currentExample = [[KWExampleGroupBuilder sharedExampleGroupBuilder] currentExample];
    id<KWVerifying> verifier = currentExample.unassignedVerifier;
    if (verifier && ![verifier subject] && [verifier isKindOfClass:[KWMatchVerifier class]]) {
        KWMatchVerifier *matchVerifier = (KWMatchVerifier *)verifier;
        [matchVerifier performSelector:@selector(beNil)];
        currentExample.unassignedVerifier = nil;
        return NO;
    }
    return YES;
}

@end
