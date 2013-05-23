//
//  KWProbePoller.m
//  iOSFalconCore
//
//  Created by Luke Redpath on 13/01/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import "KWProbePoller.h"

@interface KWTimeout : NSObject {
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

- (void)dealloc
{
  [timeoutDate release];
  [super dealloc];
}

- (BOOL)hasTimedOut
{
  return [timeoutDate timeIntervalSinceDate:[NSDate date]] < 0;
}

@end


@interface KWProbePoller() {
    NSTimeInterval timeoutInterval;
    NSTimeInterval delayInterval;
    BOOL shouldWait;
}
@end

@implementation KWProbePoller

- (id)initWithTimeout:(NSTimeInterval)theTimeout delay:(NSTimeInterval)theDelay shouldWait:(BOOL)wait;
{
  if ((self = [super init])) {
    timeoutInterval = theTimeout;
    delayInterval = theDelay;
		shouldWait = wait;
  }
  return self;
}

- (BOOL)check:(id<KWProbe>)probe;
{
  KWTimeout *timeout = [[KWTimeout alloc] initWithTimeout:timeoutInterval];

  while (shouldWait || ![probe isSatisfied]) {
    if ([timeout hasTimedOut]) {
      [timeout release];
      return [probe isSatisfied];
    }
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:delayInterval]];
    [probe sample];
  }
  [timeout release];

  return YES;
}

@end
