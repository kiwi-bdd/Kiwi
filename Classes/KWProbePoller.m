//
//  KWProbePoller.m
//  iOSFalconCore
//
//  Created by Luke Redpath on 13/01/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import "KWProbePoller.h"

@interface KWTimeout : NSObject
{
  NSDate *timeoutDate;
}
- (id)initWithTimeout:(NSTimeInterval)timeout;
- (BOOL)hasTimedOut;
@end

@implementation KWTimeout

- (id)initWithTimeout:(NSTimeInterval)timeout
{
  if ((self = [super init])) {
    timeoutDate = [[NSDate alloc] initWithTimeIntervalSinceNow:timeout];
  }
  return self;
}


- (BOOL)hasTimedOut
{
  return [timeoutDate timeIntervalSinceDate:[NSDate date]] < 0;
}

@end

#pragma mark -

@implementation KWProbePoller

- (id)initWithTimeout:(NSTimeInterval)theTimeout delay:(NSTimeInterval)theDelay;
{
  if ((self = [super init])) {
    timeoutInterval = theTimeout;
    delayInterval = theDelay;
  }
  return self;
}

- (BOOL)check:(id<KWProbe>)probe;
{
  KWTimeout *timeout = [[KWTimeout alloc] initWithTimeout:timeoutInterval];

  while (![probe isSatisfied]) {
    if ([timeout hasTimedOut]) {
      return NO;
    }
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:delayInterval]];
    [probe sample];
  }

  return YES;
}

@end
