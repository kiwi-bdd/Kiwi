//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "NSInvocation+KiwiAdditions.h"

#import <objc/runtime.h>

#import "KWFormatter.h"
#import "KWObjCUtilities.h"
#import "NSMethodSignature+KiwiAdditions.h"

#import "KWBlockInvocation.h"

@implementation NSInvocation(KiwiAdditions)

#pragma mark - Creating NSInvocation Objects

+ (NSInvocation *)invocationWithTarget:(id)anObject selector:(SEL)aSelector {
    return [self invocationWithTarget:anObject selector:aSelector messageArguments:nil];
}

+ (NSInvocation *)invocationWithTarget:(id)anObject selector:(SEL)aSelector messageArguments:(const void *)firstBytes, ... {
    va_list argumentList;
    va_start(argumentList, firstBytes);

    return [self invocationWithTarget:anObject
                             selector:aSelector 
                        firstArgument:firstBytes
                         argumentList:argumentList];
}

+ (NSInvocation *)invocationWithTarget:(id)anObject
                              selector:(SEL)aSelector
                         firstArgument:(const void *)firstBytes
                          argumentList:(va_list)argumentList
{
    if (anObject == nil) {
        [NSException raise:NSInvalidArgumentException format:@"%@ - target must not be nil",
         NSStringFromSelector(_cmd)];
    }
    
    NSMethodSignature *signature = [anObject methodSignatureForSelector:aSelector];
    
    if (signature == nil) {
        [NSException raise:NSInvalidArgumentException format:@"%@ - target returned nil for -methodSignatureForSelector",
         NSStringFromSelector(_cmd)];
    }
    
    NSInvocation *invocation = [self invocationWithMethodSignature:signature];
    [invocation setTarget:anObject];
    [invocation setSelector:aSelector];
    
    [invocation setMessageArgumentsWithFirstArgument:firstBytes argumentList:argumentList];
    
    return invocation;
}

#pragma mark - Accessing Message Arguments

- (NSData *)messageArgumentDataAtIndex:(NSUInteger)anIndex {
    NSUInteger length =  KWObjCTypeLength([[self methodSignature] messageArgumentTypeAtIndex:anIndex]);
    void *buffer = malloc(length);
    [self getMessageArgument:buffer atIndex:anIndex];
    // NSData takes over ownership of buffer
    NSData* data = [NSData dataWithBytesNoCopy:buffer length:length];
    return data;
}

- (void)getMessageArgument:(void *)buffer atIndex:(NSUInteger)anIndex {
    [self getArgument:buffer atIndex:anIndex + self.argumentOffset];
}

- (void)setMessageArgument:(const void *)bytes atIndex:(NSUInteger)anIndex {
    [self setArgument:(void *)bytes atIndex:anIndex + self.argumentOffset];
}

- (void)setMessageArguments:(const void *)firstBytes, ... {
    va_list argumentList;
    va_start(argumentList, firstBytes);

    [self setMessageArgumentsWithFirstArgument:firstBytes argumentList:argumentList];
}

- (void)setMessageArgumentsWithFirstArgument:(const void *)firstBytes argumentList:(va_list)argumentList {
    NSUInteger numberOfMessageArguments = [[self methodSignature] numberOfMessageArguments];
    
    if (numberOfMessageArguments == 0) {
        return;
        va_end(argumentList);
    }
        
    const void *bytes = firstBytes;
    
    for (NSUInteger i = 0; i < numberOfMessageArguments && bytes != nil; ++i) {
        [self setMessageArgument:bytes atIndex:i];
        bytes = va_arg(argumentList, const void *);
    }
    
    va_end(argumentList);
}

#pragma mark - Argument Offset

- (NSUInteger)argumentOffset {
    return 2;
}

#pragma mark - Block Invocation

- (void)becomeBlockInvocation {
    object_setClass(self, [KWBlockInvocation class]);
}


@end
