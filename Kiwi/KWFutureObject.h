//
//  KWFutureObject.h
//  iOSFalconCore
//
//  Created by Luke Redpath on 13/01/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id (^KWFutureObjectBlock)(void);

@interface KWFutureObject : NSObject {
  id *objectPointer;
  KWFutureObjectBlock block;
}
+ (id)objectWithObjectPointer:(id *)pointer;
+ (id)objectWithReturnValueOfBlock:(KWFutureObjectBlock)block;
- (id)initWithObjectPointer:(id *)pointer;
- (id)initWithBlock:(KWFutureObjectBlock)aBlock;
- (id)object;
@end
