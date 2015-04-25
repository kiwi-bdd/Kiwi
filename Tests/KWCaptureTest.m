//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"
#import "KWIntercept.h"
#import "NSMethodSignature+KiwiAdditions.h"
#import "KWMock.h"

#if KW_TESTS_ENABLED

@interface KWCaptureTest : XCTestCase

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
    
    XCTAssertTrue(didCall, @"Should have captured and invoked block");
}

- (void)testShouldBeAbleToCaptureObjects {
    id robotMock = [KWMock nullMockForClass:[Robot class]];
    KWCaptureSpy *spy = [robotMock captureArgument:@selector(speak:afterDelay:whenDone:) atIndex:0];

    [robotMock speak:@"Hello" afterDelay:2 whenDone:^{}];

    XCTAssertEqualObjects(spy.argument, @"Hello", @"Captured argument should be equal to 'Hello'");
}

- (void)testShouldBeAbleToCaptureAndRetainObjectsThatWouldBeDeallocated {
	id mutableArrayMock = [KWMock nullMockForClass:[NSMutableArray class]];
	KWCaptureSpy *spy = [mutableArrayMock captureArgument:@selector(addObject:) atIndex:0];

	NSDictionary *value = [[NSDictionary alloc] initWithObjectsAndKeys:@"Value", @"Key", nil];

	[mutableArrayMock addObject:value];
	[value release];
	value = nil;

	NSDictionary *spyValue = spy.argument;
	XCTAssertNotNil(spyValue, @"Captured value should not be nil");
	XCTAssertEqualObjects(spyValue, @{@"Key" : @"Value"}, @"spy value is not equal to expected value");
}

- (void)testShouldBeAbleToCaptureValues {
    id robotMock = [KWMock nullMockForClass:[Robot class]];
    KWCaptureSpy *spy = [robotMock captureArgument:@selector(speak:afterDelay:whenDone:) atIndex:1];
    
    [robotMock speak:@"Hello" afterDelay:2 whenDone:^{}];

    XCTAssertEqualObjects(spy.argument, [KWValue valueWithDouble:2], @"Captured argument should be equal to '2'");
}

- (void)testShouldBeAbleToCaptureClasses {
	id robotMock = [KWMock nullMockForClass:[Robot class]];
	KWCaptureSpy *spy = [robotMock captureArgument:@selector(speak:ofType:) atIndex:1];

	[robotMock speak:@"Hello" ofType:[NSString class]];

	XCTAssertEqualObjects(spy.argument, [NSString class], @"Captured argument should be equal to [NSString class]");
}

- (void)testShouldBeAbleToCaptureNils {
    id robotMock = [KWMock nullMockForClass:[Robot class]];
    KWCaptureSpy *spy = [robotMock captureArgument:@selector(speak:afterDelay:whenDone:) atIndex:0];
    
    [robotMock speak:nil afterDelay:2 whenDone:^{}];
    
    XCTAssertNil(spy.argument, @"Captured argument should be nil");
}

- (void)testShouldRaiseAnExceptionIfArgumentHasNotBeenCaptured {
    id robotMock = [KWMock nullMockForClass:[Robot class]];
    KWCaptureSpy *spy = [robotMock captureArgument:@selector(speak:afterDelay:whenDone:) atIndex:1];
    
    XCTAssertThrows([spy argument], @"Should have raised an exception");
}

- (void)testAddSpyConvenienceMethodOnNSObject {
	Robot *robot = [[Robot alloc] init];
	KWCaptureSpy *spy = [robot captureArgument:@selector(speak:) atIndex:0];

	[robot speak:@"Hello"];

	XCTAssertEqualObjects(spy.argument, @"Hello", @"Captured argument from NSObject convenience method based spy should be equal to 'Hello'");
}

- (void)tearDown {
    KWClearStubsAndSpies();
}
@end

#endif