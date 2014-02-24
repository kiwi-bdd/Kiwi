//
//  KWBlockProxy.h
//  Kiwi
//
//  Created by Adam Sharp on 24/02/2014.
//  Copyright (c) 2014 Allen Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^KWBlockInvocationProxy)(NSInvocation *inv, void (^call)(void));

@interface KWBlockProxy : NSObject

- (id)initWithBlock:(id)block;

@property (nonatomic, copy) KWBlockInvocationProxy invocationProxy;

@end
