//
//  KWFutureObject.h
//  iOSFalconCore
//
//  Created by Luke Redpath on 13/01/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KWFutureObject : NSObject {
  id *objectPointer;
}
+ (id)objectWithObjectPointer:(id *)pointer;
- (id)initWithObjectPointer:(id *)pointer;
- (id)object;
@end
