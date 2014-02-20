//
// Licensed under the terms in License.txt
//
// Copyright 2014 Allen Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KWExample.h"

@interface KWExampleNotification : NSObject

@property (nonatomic, readonly) KWExample *example;

- (id)initWithExample:(KWExample *)example;

@end
