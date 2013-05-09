//
//  KWFutureObject.m
//  iOSFalconCore
//
//  Created by Luke Redpath on 13/01/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import "KWFutureObject.h"

@interface KWFutureObject() {
    KWFutureObjectBlock block;
}
@end

@implementation KWFutureObject

+ (id)objectWithObjectPointer:(id *)pointer;
{
  return [self futureObjectWithBlock:^{ return *pointer; }];
}

+ (id)futureObjectWithBlock:(KWFutureObjectBlock)block;
{
  return [[[self alloc] initWithBlock:block] autorelease];
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
  return block();
}

- (void)dealloc
{
  [block release];
  [super dealloc];
}

@end
