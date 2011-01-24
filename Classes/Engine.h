//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Engine : NSObject
@property (nonatomic, copy) NSString *model;

+ (id)engineWithModel:(NSString *)modelName;
@end
