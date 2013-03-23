//
// Licensed under the terms in License.txt
//
// Copyright 2013 Stepan Hruda. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KWWeakPointer : NSObject <NSCopying>

@property (nonatomic, weak) id object;

+ (KWWeakPointer *)weakPointerToObject:(id)object;

@end
