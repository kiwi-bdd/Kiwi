//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "NSObject+KiwiStubAdditions.h"
#import "KWCaptureSpy.h"
#import "KWIntercept.h"
#import "KWInvocationCapturer.h"
#import "KWSelectorMessagePattern.h"
#import "KWObjCUtilities.h"
#import "KWStringUtilities.h"
#import "KWStub.h"

static NSString * const StubValueKey = @"StubValueKey";
static NSString * const StubSecondValueKey = @"StubSecondValueKey";
static NSString * const ChangeStubValueAfterTimesKey = @"ChangeStubValueAfterTimesKey";

@implementation NSObject(KiwiStubAdditions)

#pragma mark - Capturing Invocations

- (NSMethodSignature *)invocationCapturer:(KWInvocationCapturer *)anInvocationCapturer methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];

    if (signature != nil)
        return signature;

    NSString *encoding = KWEncodingForDefaultMethod();
    return [NSMethodSignature signatureWithObjCTypes:[encoding UTF8String]];
}

- (void)invocationCapturer:(KWInvocationCapturer *)anInvocationCapturer didCaptureInvocation:(NSInvocation *)anInvocation {
    KWSelectorMessagePattern *messagePattern = [KWSelectorMessagePattern messagePatternFromInvocation:anInvocation];
    id value = (anInvocationCapturer.userInfo)[StubValueKey];
    if (!(anInvocationCapturer.userInfo)[StubSecondValueKey]) {
        [self stubMessagePattern:messagePattern andReturn:value];
    } else {
        id times = (anInvocationCapturer.userInfo)[ChangeStubValueAfterTimesKey];
        id secondValue = (anInvocationCapturer.userInfo)[StubSecondValueKey];
        [self stubMessagePattern:messagePattern andReturn:value times:times afterThatReturn:secondValue];
    }
}

#pragma mark - Stubbing Methods

- (void)stub:(SEL)aSelector {
    KWSelectorMessagePattern *messagePattern = [KWSelectorMessagePattern messagePatternWithSelector:aSelector];
    [self stubMessagePattern:messagePattern andReturn:nil];
}

- (void)stub:(SEL)aSelector withBlock:(id (^)(NSArray *))block {
    KWSelectorMessagePattern *messagePattern = [KWSelectorMessagePattern messagePatternWithSelector:aSelector];
    [self stubMessagePattern:messagePattern withBlock:block];
}

- (void)stub:(SEL)aSelector withArguments:(id)firstArgument, ... {
    va_list argumentList;
    va_start(argumentList, firstArgument);
    KWSelectorMessagePattern *messagePattern = [KWSelectorMessagePattern messagePatternWithSelector:aSelector firstArgumentFilter:firstArgument argumentList:argumentList];
    [self stubMessagePattern:messagePattern andReturn:nil];
}

- (void)stub:(SEL)aSelector andReturn:(id)aValue {
    KWSelectorMessagePattern *messagePattern = [KWSelectorMessagePattern messagePatternWithSelector:aSelector];
    [self stubMessagePattern:messagePattern andReturn:aValue];
}

- (void)stub:(SEL)aSelector andReturn:(id)aValue withArguments:(id)firstArgument, ... {
    va_list argumentList;
    va_start(argumentList, firstArgument);
    KWSelectorMessagePattern *messagePattern = [KWSelectorMessagePattern messagePatternWithSelector:aSelector firstArgumentFilter:firstArgument argumentList:argumentList];
    [self stubMessagePattern:messagePattern andReturn:aValue];
}

- (void)stub:(SEL)aSelector andReturn:(id)aValue times:(NSNumber *)times afterThatReturn:(id)aSecondValue {
    KWSelectorMessagePattern *messagePattern = [KWSelectorMessagePattern messagePatternWithSelector:aSelector];
    [self stubMessagePattern:messagePattern andReturn:aValue times:times afterThatReturn:aSecondValue];
}

+ (void)stub:(SEL)aSelector {
    KWSelectorMessagePattern *messagePattern = [KWSelectorMessagePattern messagePatternWithSelector:aSelector];
    [self stubMessagePattern:messagePattern andReturn:nil];
}

+ (void)stub:(SEL)aSelector withBlock:(id (^)(NSArray *))block {
    KWSelectorMessagePattern *messagePattern = [KWSelectorMessagePattern messagePatternWithSelector:aSelector];
    [self stubMessagePattern:messagePattern withBlock:block];
}

+ (void)stub:(SEL)aSelector withArguments:(id)firstArgument, ... {
    va_list argumentList;
    va_start(argumentList, firstArgument);
    KWSelectorMessagePattern *messagePattern = [KWSelectorMessagePattern messagePatternWithSelector:aSelector firstArgumentFilter:firstArgument argumentList:argumentList];
    [self stubMessagePattern:messagePattern andReturn:nil];
}

+ (void)stub:(SEL)aSelector andReturn:(id)aValue {
    KWSelectorMessagePattern *messagePattern = [KWSelectorMessagePattern messagePatternWithSelector:aSelector];
    [self stubMessagePattern:messagePattern andReturn:aValue];
}

+ (void)stub:(SEL)aSelector andReturn:(id)aValue withArguments:(id)firstArgument, ... {
    va_list argumentList;
    va_start(argumentList, firstArgument);
    KWSelectorMessagePattern *messagePattern = [KWSelectorMessagePattern messagePatternWithSelector:aSelector firstArgumentFilter:firstArgument argumentList:argumentList];
    [self stubMessagePattern:messagePattern andReturn:aValue];
}

+ (void)stub:(SEL)aSelector andReturn:(id)aValue times:(NSNumber *)times afterThatReturn:(id)aSecondValue {
    KWSelectorMessagePattern *messagePattern = [KWSelectorMessagePattern messagePatternWithSelector:aSelector];
    [self stubMessagePattern:messagePattern andReturn:aValue times:times afterThatReturn:aSecondValue];
}

- (void)stubMessagePattern:(KWSelectorMessagePattern *)aMessagePattern andReturn:(id)aValue {
    [self stubMessagePattern:aMessagePattern andReturn:aValue overrideExisting:YES];
}

- (void)stubMessagePattern:(KWSelectorMessagePattern *)aMessagePattern andReturn:(id)aValue overrideExisting:(BOOL)overrideExisting {
    if ([self methodSignatureForSelector:aMessagePattern.selector] == nil) {
        [NSException raise:@"KWStubException" format:@"cannot stub -%@ because no such method exists",
         NSStringFromSelector(aMessagePattern.selector)];
    }
    
    Class interceptClass = KWSetupObjectInterceptSupport(self);
    KWSetupMethodInterceptSupport(interceptClass, aMessagePattern.selector);
    KWStub *stub = [KWStub stubWithMessagePattern:aMessagePattern value:aValue];
    KWAssociateObjectStub(self, stub, overrideExisting);
}

- (void)stubMessagePattern:(KWSelectorMessagePattern *)aMessagePattern andReturn:(id)aValue times:(id)times afterThatReturn:(id)aSecondValue {
    if ([self methodSignatureForSelector:aMessagePattern.selector] == nil) {
        [NSException raise:@"KWStubException" format:@"cannot stub -%@ because no such method exists",
         NSStringFromSelector(aMessagePattern.selector)];
    }

    Class interceptClass = KWSetupObjectInterceptSupport(self);
    KWSetupMethodInterceptSupport(interceptClass, aMessagePattern.selector);
    KWStub *stub = [KWStub stubWithMessagePattern:aMessagePattern value:aValue times:times afterThatReturn:aSecondValue];
    KWAssociateObjectStub(self, stub, YES);
}

- (void)stubMessagePattern:(KWSelectorMessagePattern *)aMessagePattern withBlock:(id (^)(NSArray *params))block {
    if ([self methodSignatureForSelector:aMessagePattern.selector] == nil) {
        [NSException raise:@"KWStubException" format:@"cannot stub -%@ because no such method exists",
         NSStringFromSelector(aMessagePattern.selector)];
    }
    
    Class interceptClass = KWSetupObjectInterceptSupport(self);
    KWSetupMethodInterceptSupport(interceptClass, aMessagePattern.selector);
    KWStub *stub = [KWStub stubWithMessagePattern:aMessagePattern block:block];
    KWAssociateObjectStub(self, stub, YES);
}

+ (void)stubMessagePattern:(KWSelectorMessagePattern *)aMessagePattern andReturn:(id)aValue {
    [self stubMessagePattern:aMessagePattern andReturn:aValue overrideExisting:YES];
}

+ (void)stubMessagePattern:(KWSelectorMessagePattern *)aMessagePattern andReturn:(id)aValue overrideExisting:(BOOL)override {
    if ([self methodSignatureForSelector:aMessagePattern.selector] == nil) {
        [NSException raise:@"KWStubException" format:@"cannot stub -%@ because no such method exists",
         NSStringFromSelector(aMessagePattern.selector)];
    }
    
    Class interceptClass = KWSetupObjectInterceptSupport(self);
    KWSetupMethodInterceptSupport(interceptClass, aMessagePattern.selector);
    KWStub *stub = [KWStub stubWithMessagePattern:aMessagePattern value:aValue];
    KWAssociateObjectStub(self, stub, override);
}

+ (void)stubMessagePattern:(KWSelectorMessagePattern *)aMessagePattern andReturn:(id)aValue times:(id)times afterThatReturn:(id)aSecondValue {
    [self stubMessagePattern:aMessagePattern andReturn:aValue times:times afterThatReturn:aSecondValue overrideExisting:YES];
}

+ (void)stubMessagePattern:(KWSelectorMessagePattern *)aMessagePattern andReturn:(id)aValue times:(id)times afterThatReturn:(id)aSecondValue overrideExisting:(BOOL)override {
    if ([self methodSignatureForSelector:aMessagePattern.selector] == nil) {
        [NSException raise:@"KWStubException" format:@"cannot stub -%@ because no such method exists",
         NSStringFromSelector(aMessagePattern.selector)];
    }
    
    Class interceptClass = KWSetupObjectInterceptSupport(self);
    KWSetupMethodInterceptSupport(interceptClass, aMessagePattern.selector);
    KWStub *stub = [KWStub stubWithMessagePattern:aMessagePattern value:aValue times:times afterThatReturn:aSecondValue];
    KWAssociateObjectStub(self, stub, override);
}

+ (void)stubMessagePattern:(KWSelectorMessagePattern *)aMessagePattern withBlock:(id (^)(NSArray *params))block {
    [self stubMessagePattern:aMessagePattern withBlock:block overrideExisting:YES];
}

+ (void)stubMessagePattern:(KWSelectorMessagePattern *)aMessagePattern withBlock:(id (^)(NSArray *params))block  overrideExisting:(BOOL)override {
    if ([self methodSignatureForSelector:aMessagePattern.selector] == nil) {
        [NSException raise:@"KWStubException" format:@"cannot stub -%@ because no such method exists",
         NSStringFromSelector(aMessagePattern.selector)];
    }
    
    Class interceptClass = KWSetupObjectInterceptSupport(self);
    KWSetupMethodInterceptSupport(interceptClass, aMessagePattern.selector);
    KWStub *stub = [KWStub stubWithMessagePattern:aMessagePattern block:block];
    KWAssociateObjectStub(self, stub, override);
}

- (void)clearStubs {
    KWClearObjectStubs(self);
}

#pragma mark - Spying on Messages

- (void)addMessageSpy:(id<KWMessageSpying>)aSpy forMessagePattern:(KWSelectorMessagePattern *)aMessagePattern {
    if ([self methodSignatureForSelector:aMessagePattern.selector] == nil) {
        [NSException raise:@"KWSpyException" format:@"cannot add spy for -%@ because no such method exists",
         NSStringFromSelector(aMessagePattern.selector)];
    }

    Class interceptClass = KWSetupObjectInterceptSupport(self);
    KWSetupMethodInterceptSupport(interceptClass, aMessagePattern.selector);
    KWAssociateMessageSpy(self, aSpy, aMessagePattern);
}

- (void)removeMessageSpy:(id<KWMessageSpying>)aSpy forMessagePattern:(KWSelectorMessagePattern *)aMessagePattern {
    KWClearObjectSpy(self, aSpy, aMessagePattern);
}

+ (void)addMessageSpy:(id<KWMessageSpying>)aSpy forMessagePattern:(KWSelectorMessagePattern *)aMessagePattern {
    if ([self methodSignatureForSelector:aMessagePattern.selector] == nil) {
        [NSException raise:@"KWSpyException" format:@"cannot add spy for -%@ because no such method exists",
         NSStringFromSelector(aMessagePattern.selector)];
    }
    
    Class interceptClass = KWSetupObjectInterceptSupport(self);
    KWSetupMethodInterceptSupport(interceptClass, aMessagePattern.selector);
    KWAssociateMessageSpy(self, aSpy, aMessagePattern);
}

+ (void)removeMessageSpy:(id<KWMessageSpying>)aSpy forMessagePattern:(KWSelectorMessagePattern *)aMessagePattern {
    KWClearObjectSpy(self, aSpy, aMessagePattern);
}

@end
