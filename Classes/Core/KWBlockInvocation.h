//
//  NSBlockInvocation.h
//  Kiwi
//
//  Created by Oleksa 'trimm' Korin on 4/27/16.
//  Copyright © 2016 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"

#import "NSInvocation+KiwiAdditions.h"

@interface KWBlockInvocation : NSInvocation

#pragma mark - Creating NSInvocation Objects

+ (NSInvocation *)invocationWithTarget:(id)anObject;
+ (NSInvocation *)invocationWithTarget:(id)anObject messageArguments:(const void *)firstBytes, ...;
+ (NSInvocation *)invocationWithTarget:(id)anObject
                         firstArgument:(const void *)firstBytes
                          argumentList:(va_list)argumentList;

@end
