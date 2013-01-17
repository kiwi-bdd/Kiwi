//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"

@protocol KWInvocationCapturerDelegate;

@interface KWInvocationCapturer : NSProxy {
@private
    id delegate;
    NSDictionary *userInfo;
}

#pragma mark -
#pragma mark Initializing

- (id)initWithDelegate:(id)aDelegate;
- (id)initWithDelegate:(id)aDelegate userInfo:(NSDictionary *)aUserInfo;

+ (id)invocationCapturerWithDelegate:(id)aDelegate;
+ (id)invocationCapturerWithDelegate:(id)aDelegate userInfo:(NSDictionary *)aUserInfo;

#pragma mark -
#pragma mark Properties

@property (nonatomic, readonly) id delegate;
@property (nonatomic, readonly) NSDictionary *userInfo;

@end

@protocol KWInvocationCapturerDelegate

#pragma mark -
#pragma mark Capturing Invocations

- (NSMethodSignature *)invocationCapturer:(KWInvocationCapturer *)anInvocationCapturer methodSignatureForSelector:(SEL)aSelector;
- (void)invocationCapturer:(KWInvocationCapturer *)anInvocationCapturer didCaptureInvocation:(NSInvocation *)anInvocation;

@end
