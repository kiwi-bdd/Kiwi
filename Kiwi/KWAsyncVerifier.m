//
//  KWAsyncVerifier.m
//  iOSFalconCore
//
//  Created by Luke Redpath on 13/01/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import "KWAsyncVerifier.h"
#import "KWFailure.h"
#import "KWMatching.h"
#import "KWReporting.h"
#import "KWProbePoller.h"

@implementation KWAsyncVerifier

- (void)verifyWithProbe:(KWAsyncMatcherProbe *)aProbe {
  @try {
    KWProbePoller *poller = [[KWProbePoller alloc] initWithTimeout:3.0 delay:kKW_DEFAULT_PROBE_DELAY];

    if (![poller check:aProbe]) {
      if (self.expectationType == KWExpectationTypeShould) {
        NSString *message = [aProbe.matcher failureMessageForShould];
        KWFailure *failure = [KWFailure failureWithCallSite:self.callSite message:message];
        [self.reporter reportFailure:failure];
      } else if (self.expectationType == KWExpectationTypeShouldNot) {
        NSString *message = [aProbe.matcher failureMessageForShouldNot];
        KWFailure *failure = [KWFailure failureWithCallSite:self.callSite message:message];
        [self.reporter reportFailure:failure];
      }
    }
    [poller release];
    
  } @catch (NSException *exception) {
    KWFailure *failure = [KWFailure failureWithCallSite:self.callSite message:[exception description]];
    [self.reporter reportFailure:failure];        
  }
}

- (void)verifyWithMatcher:(id<KWMatching>)aMatcher {
  KWAsyncMatcherProbe *probe = [[[KWAsyncMatcherProbe alloc] initWithMatcher:aMatcher] autorelease];
  [self verifyWithProbe:probe];
}

@end

@implementation KWAsyncMatcherProbe

@synthesize matcher;

- (id)initWithMatcher:(id<KWMatching>)aMatcher;
{
  if (self = [super init]) {
    matcher = [aMatcher retain];
  }
  return self;
}

- (void)dealloc
{
  [matcher release];
  [super dealloc];
}

- (BOOL)isSatisfied;
{
  return matchResult;
}

- (void)sample;
{
  matchResult = [matcher evaluate];
}

@end

