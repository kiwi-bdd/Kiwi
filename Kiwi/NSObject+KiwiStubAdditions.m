//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "NSObject+KiwiStubAdditions.h"
#import "KWIntercept.h"
#import "KWInvocationCapturer.h"
#import "KWMessagePattern.h"
#import "KWObjCUtilities.h"
#import "KWStringUtilities.h"
#import "KWStub.h"

static NSString * const StubValueKey = @"StubValueKey";

@implementation NSObject(KiwiStubAdditions)

#pragma mark -
#pragma mark Capturing Invocations

- (NSMethodSignature *)invocationCapturer:(KWInvocationCapturer *)anInvocationCapturer methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [self methodSignatureForSelector:aSelector];
    
    if (signature != nil)
        return signature;

    NSString *encoding = KWEncodingForVoidMethod();
    return [NSMethodSignature signatureWithObjCTypes:[encoding UTF8String]];
}

- (void)invocationCapturer:(KWInvocationCapturer *)anInvocationCapturer didCaptureInvocation:(NSInvocation *)anInvocation {
    KWMessagePattern *messagePattern = [KWMessagePattern messagePatternFromInvocation:anInvocation];
    id value = [anInvocationCapturer.userInfo objectForKey:StubValueKey];
    [self stubMessagePattern:messagePattern andReturn:value];
}

#pragma mark -
#pragma mark Stubbing Methods

- (void)stub:(SEL)aSelector {
    KWMessagePattern *messagePattern = [KWMessagePattern messagePatternWithSelector:aSelector];
    [self stubMessagePattern:messagePattern andReturn:nil];
}

- (void)stub:(SEL)aSelector withArguments:(id)firstArgument, ... {
    va_list argumentList;
    va_start(argumentList, firstArgument);
    KWMessagePattern *messagePattern = [KWMessagePattern messagePatternWithSelector:aSelector firstArgumentFilter:firstArgument argumentList:argumentList];
    [self stubMessagePattern:messagePattern andReturn:nil];
}

- (void)stub:(SEL)aSelector andReturn:(id)aValue {
    KWMessagePattern *messagePattern = [KWMessagePattern messagePatternWithSelector:aSelector];
    [self stubMessagePattern:messagePattern andReturn:aValue];
}

- (void)stub:(SEL)aSelector andReturn:(id)aValue withArguments:(id)firstArgument, ... {
    va_list argumentList;
    va_start(argumentList, firstArgument);
    KWMessagePattern *messagePattern = [KWMessagePattern messagePatternWithSelector:aSelector firstArgumentFilter:firstArgument argumentList:argumentList];
    [self stubMessagePattern:messagePattern andReturn:aValue];
}

- (id)stub {
    return [KWInvocationCapturer invocationCapturerWithDelegate:self];
}

- (id)stubAndReturn:(id)aValue {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:aValue forKey:StubValueKey];
    return [KWInvocationCapturer invocationCapturerWithDelegate:self userInfo:userInfo];
}

- (void)stubMessagePattern:(KWMessagePattern *)aMessagePattern andReturn:(id)aValue {
    if ([self methodSignatureForSelector:aMessagePattern.selector] == nil) {
        [NSException raise:@"KWStubException" format:@"cannot stub -%@ because no such method exists",
                                                     NSStringFromSelector(aMessagePattern.selector)];
    }
    
    Class interceptClass = KWSetupObjectInterceptSupport(self);
    KWSetupMethodInterceptSupport(interceptClass, aMessagePattern.selector);
    KWStub *stub = [KWStub stubWithMessagePattern:aMessagePattern value:aValue];
    KWAssociateObjectStub(self, stub);
}

- (void)clearStubs {
    KWClearObjectStubs(self);
}

#pragma mark -
#pragma mark Spying on Messages

- (void)addMessageSpy:(id<KWMessageSpying>)aSpy forMessagePattern:(KWMessagePattern *)aMessagePattern {
    if ([self methodSignatureForSelector:aMessagePattern.selector] == nil) {
        [NSException raise:@"KWSpyException" format:@"cannot add spy for -%@ because no such method exists",
         NSStringFromSelector(aMessagePattern.selector)];
    }
    
    Class interceptClass = KWSetupObjectInterceptSupport(self);
    KWSetupMethodInterceptSupport(interceptClass, aMessagePattern.selector);
    KWAssociateMessageSpy(self, aSpy, aMessagePattern);
}

- (void)removeMessageSpy:(id<KWMessageSpying>)aSpy forMessagePattern:(KWMessagePattern *)aMessagePattern {
    KWClearObjectSpy(self, aSpy, aMessagePattern);
}

@end
