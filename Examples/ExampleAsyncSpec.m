//
//  ExampleAsyncSpec.m
//  Kiwi
//
//  Created by Luke Redpath on 17/01/2011.
//  Copyright 2011 Allen Ding. All rights reserved.
//

#import "KiwiTestConfiguration.h"
#import "TestClasses.h"
#import "Kiwi.h"

#if KW_TESTS_ENABLED

SPEC_BEGIN(ExampleAsyncSpec)

const float nanosecondToSeconds = 1e9;

context(@"Asynchronous specs", ^{
  it(@"should verify asynchronous expectations on a variable that starts as nil that succeed in time", ^{
    __block NSString *fetchedData = nil;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * nanosecondToSeconds), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
      fetchedData = @"expected response data";
    });
    
    // this will block until the matcher is satisfied or it times out (default: 1s)
    [[expectFutureValue(fetchedData) shouldEventually] equal:@"expected response data"];
  });
  
  it(@"should verify asynchronous expectations on a variable that starts as nil that succeed with an explicit time", ^{
    __block NSString *fetchedData = nil;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * nanosecondToSeconds), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
      fetchedData = @"expected response data";
    });
    
    // this will block until the matcher is satisfied or it times out (default: 1s)
    [[expectFutureValue(fetchedData) shouldEventuallyBeforeTimingOutAfter(2.0)] equal:@"expected response data"];
  });
  
  it(@"should verify asynchronous expectations on the return value of a block", ^{
    __block NSString *fetchedData = nil;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * nanosecondToSeconds), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
      fetchedData = @"expected response data";
    });
    
    [[expectFutureValue([fetchedData uppercaseString]) shouldEventually] equal:@"EXPECTED RESPONSE DATA"];
  });
  
  it(@"should verify asynchronous mock expectations on an existing object set before the asynchronous call", ^{
    __block id mock = [KWMock mockForClass:[NSString class]];
    
    [[[mock shouldEventually] receive] uppercaseString];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * nanosecondToSeconds), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
      [mock uppercaseString];
    });
  });
  
  it(@"should verify asynchronous mock expectations on an existing object set after the asynchronous call", ^{
    __block id mock = [KWMock mockForClass:[NSString class]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * nanosecondToSeconds), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
      [mock uppercaseString];
    });
    
    [[[mock shouldEventually] receive] uppercaseString];
  });
  
  it(@"should verify asynchronous expectations on a variable that starts as nil and becomes not-nil", ^{
    __block NSString *fetchedData = nil;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * nanosecondToSeconds), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
      fetchedData = @"expected response data";
    });
    
    // this will block until the matcher is satisfied or it times out (default: 1s)
    [[expectFutureValue(fetchedData) shouldEventually] beNonNil];
  });
  
  it(@"should verify asynchronous expectations on a variable that starts as non-nil and becomes nil", ^{
    __block NSString *fetchedData = @"not nil";
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * nanosecondToSeconds), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
      fetchedData = nil;
    });
    
    // this will block until the matcher is satisfied or it times out (default: 1s)
    [[expectFutureValue(fetchedData) shouldEventually] beNil];
  });
});

SPEC_END

#endif // #if KW_TESTS_ENABLED