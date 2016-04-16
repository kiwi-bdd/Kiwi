//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"

@interface NSInvocation(KiwiAdditions)

#pragma mark - Creating NSInvocation Objects

+ (NSInvocation *)invocationWithTarget:(id)anObject selector:(SEL)aSelector;
+ (NSInvocation *)invocationWithTarget:(id)anObject selector:(SEL)aSelector messageArguments:(const void *)firstBytes, ...;

+ (NSInvocation *)invocationWithTarget:(id)anObject
                              selector:(SEL)aSelector
                         firstArgument:(const void *)firstBytes
                          argumentList:(va_list)argumentList;

#pragma mark - Accessing Message Arguments

// Message arguments are invocation arguments that begin after the target and selector arguments. These methods provide
// convenient ways to access them.

- (NSData *)messageArgumentDataAtIndex:(NSUInteger)anIndex;
- (void)getMessageArgument:(void *)buffer atIndex:(NSUInteger)anIndex;
- (void)setMessageArgument:(const void *)bytes atIndex:(NSUInteger)anIndex;
- (void)setMessageArguments:(const void *)firstBytes, ...;
- (void)setMessageArgumentsWithFirstArgument:(const void *)firstBytes argumentList:(va_list)argumentList;

#pragma mark - Argument Offset

- (NSUInteger)argumentOffset;

#pragma mark - Block Invocation

- (void)becomeBlockInvocation;

@end
