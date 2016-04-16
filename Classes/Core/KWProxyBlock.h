//
//  KWProxyBlock.h
//  Kiwi
//
//  Created by Oleksa 'trimm' Korin on 4/18/16.
//  Copyright © 2016 Allen Ding. All rights reserved.
//

#import <Foundation/NSObject.h>

@interface KWProxyBlock : NSObject <NSCopying>

#pragma mark - Initializing

+ (id)blockWithBlock:(id)block;

- (id)initWithBlock:(id)block;

#pragma mark - Properties

@property (nonatomic, readonly) NSMethodSignature   *methodSignature;

@end

#pragma mark - Creating Blocks

FOUNDATION_EXPORT
KWProxyBlock *theBlockProxy(id);

FOUNDATION_EXPORT
KWProxyBlock *lambdaProxy(id);
