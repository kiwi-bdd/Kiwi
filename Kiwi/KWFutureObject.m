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

- (id)initWithObjectPointer:(id *)pointer;
{
  if ((self = [super init])) {
    objectPointer = pointer;
  }
  return self;
}

- (id)object;
{
  return *objectPointer;
}

@end
