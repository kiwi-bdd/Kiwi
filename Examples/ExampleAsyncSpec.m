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

#if KW_TESTS_ENABLED && KW_BLOCKS_ENABLED

SPEC_BEGIN(ExampleAsyncSpec)

const float nanosecondToSeconds = 1e9;

it(@"should verify asynchronous expectations that succeed in time", ^{
  __block NSString *fetchedData = nil;
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * nanosecondToSeconds), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
    fetchedData = @"expected response data";
  });
  
  // this will block until the matcher is satisfied or it times out (default: 1s)
  [[theObject(&fetchedData) shouldEventually] equal:@"expected response data"];
});

it(@"should verify asynchronous expectations that succeed with an explicit time", ^{
  __block NSString *fetchedData = nil;
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * nanosecondToSeconds), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
    fetchedData = @"expected response data";
  });
  
  // this will block until the matcher is satisfied or it times out (default: 1s)
  [[theObject(&fetchedData) shouldEventuallyBeforeTimingOutAfter(2.0)] equal:@"expected response data"];
});


SPEC_END

#endif // #if KW_TESTS_ENABLED && KW_BLOCKS_ENABLED
