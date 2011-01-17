//
//  KWFutureObject.m
//  iOSFalconCore
//
//  Created by Luke Redpath on 13/01/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import "KWFutureObject.h"


@implementation KWFutureObject

+ (id)objectWithObjectPointer:(id *)pointer;
{
  return [[[self alloc] initWithObjectPointer:pointer] autorelease];
}

+ (id)objectWithReturnValueOfBlock:(KWFutureObjectBlock)block;
{
  return [[[self alloc] initWithBlock:block] autorelease];
}

- (id)initWithObjectPointer:(id *)pointer;
{
  if ((self = [super init])) {
    objectPointer = pointer;
  }
  return self;
}

- (id)initWithBlock:(KWFutureObjectBlock)aBlock;
{
  if ((self = [super init])) {
    block = [aBlock copy];
  }
  return self;
}

- (id)object;
{
  if (block) {
    return block();
  }
  return *objectPointer;
}

- (void)dealloc
{
  [block release];
  [super dealloc];
}

@end
