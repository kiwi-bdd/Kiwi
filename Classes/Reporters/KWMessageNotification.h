//
// Licensed under the terms in License.txt
//
// Copyright 2014 Allen Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KWMessageNotification : NSObject

@property (nonatomic, copy, readonly) NSString *message;

- (id)initWithMessage:(NSString *)message;

@end
