//
//  KWEventNotification.h
//  Kiwi
//
//  Created by Brian Ivan Gesiak on 2/12/14.
//  Copyright (c) 2014 Allen Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KWExample;

@interface KWExampleNotification : NSObject

@property (nonatomic, readonly) KWExample *example;

- (id)initWithExample:(KWExample *)example;

@end
