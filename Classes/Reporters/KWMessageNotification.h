//
//  KWMessageNotification.h
//  Kiwi
//
//  Created by Brian Ivan Gesiak on 2/12/14.
//  Copyright (c) 2014 Allen Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KWMessageNotification : NSObject

@property (nonatomic, copy, readonly) NSString *message;

- (id)initWithMessage:(NSString *)message;

@end