//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"
#import "KWIntercept.h"
#import "NSMethodSignature+KiwiAdditions.h"
#import "KWMock.h"

#if KW_TESTS_ENABLED

@interface KWCaptureTest : SenTestCase

@end

@implementation KWCaptureTest

- (void)testShouldBeAbleToCaptureBlocks {
    id robotMock = [KWMock nullMockForClass:[Robot class]];
    KWCaptureSpy *spy = [robotMock captureArgument:@selector(speak:afterDelay:whenDone:) atIndex:2];
    
    __block BOOL didCall = NO;
    [robotMock speak:@"Hello" afterDelay:2 whenDone:^{
        didCall = YES;
    }];

    void (^block)(void) = spy.argument;
    block();
    
    STAssertTrue(didCall, @"Should have captured and invoked block");
}

- (void)testShouldBeAbleToCaptureObjects {
    id robotMock = [KWMock nullMockForClass:[Robot class]];
    KWCaptureSpy *spy = [robotMock captureArgument:@selector(speak:afterDelay:whenDone:) atIndex:0];
    
    [robotMock speak:@"Hello" afterDelay:2 whenDone:^{}];
    
    STAssertEqualObjects(spy.argument, @"Hello", @"Captured argument should be equal to 'Hello'");    
}

- (void)testShouldBeAbleToCaptureValues {
    id robotMock = [KWMock nullMockForClass:[Robot class]];
    KWCaptureSpy *spy = [robotMock captureArgument:@selector(speak:afterDelay:whenDone:) atIndex:1];
    
    [robotMock speak:@"Hello" afterDelay:2 whenDone:^{}];
    
    STAssertEqualObjects(spy.argument, [KWValue valueWithDouble:2], @"Captured argument should be equal to '2'");        
}

- (void)testShouldBeAbleToCaptureNils {
    id robotMock = [KWMock nullMockForClass:[Robot class]];
    KWCaptureSpy *spy = [robotMock captureArgument:@selector(speak:afterDelay:whenDone:) atIndex:0];
    
    [robotMock speak:nil afterDelay:2 whenDone:^{}];
    
    STAssertNil(spy.argument, @"Captured argument should be nil");
}

- (void)testShouldRaiseAnExceptionIfArgumentHasNotBeenCaptured {
    id robotMock = [KWMock nullMockForClass:[Robot class]];
    KWCaptureSpy *spy = [robotMock captureArgument:@selector(speak:afterDelay:whenDone:) atIndex:1];
    
    STAssertThrows([spy argument], @"Should have raised an exception");
}

- (void)tearDown {
    KWClearStubsAndSpies();
}
@end

#endif