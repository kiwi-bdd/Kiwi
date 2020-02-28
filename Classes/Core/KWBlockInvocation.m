//
//  KWBlockInvocation.m
//  Kiwi
//
//  Created by Oleksa 'trimm' Korin on 4/27/16.
//  Copyright © 2016 Allen Ding. All rights reserved.
//

#import "KWBlockInvocation.h"

#import "KWObjCUtilities.h"
#import "NSMethodSignature+KiwiAdditions.h"
#import "KWProxyBlock.h"

@implementation KWBlockInvocation

#pragma mark - Creating NSInvocation Objects

+ (NSInvocation *)invocationWithTarget:(id)anObject {
    return [self invocationWithTarget:anObject messageArguments:nil];
}

+ (NSInvocation *)invocationWithTarget:(id)anObject messageArguments:(const void *)firstBytes, ... {
    va_list argumentList;
    va_start(argumentList, firstBytes);
    
    return [self invocationWithTarget:anObject
                             selector:@selector(_doNothing)
                        firstArgument:firstBytes
                         argumentList:argumentList];
}

+ (NSInvocation *)invocationWithTarget:(id)anObject
                         firstArgument:(const void *)firstBytes
                          argumentList:(va_list)argumentList
{
    return [self invocationWithTarget:anObject
                             selector:@selector(_doNothing)
                        firstArgument:firstBytes
                         argumentList:argumentList];
}

+ (NSInvocation *)invocationWithTarget:(id)anObject
                              selector:(SEL)aSelector
                         firstArgument:(const void *)firstBytes
                          argumentList:(va_list)argumentList
{
    if (![anObject isMemberOfClass:[KWProxyBlock class]]) {
        [NSException raise:NSInvalidArgumentException format:@"%@ - target must be KWProxyBlock", anObject];
    }
    
    return [super invocationWithTarget:anObject
                              selector:@selector(_doNothing)
                         firstArgument:firstBytes
                          argumentList:argumentList];
}

#pragma mark - Argument Offset

- (NSUInteger)argumentOffset {
    return 1;
}

#pragma mark - Properties

- (void)_doNothing {
    
}

@end
