//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Engine.h"

@implementation Engine

@synthesize model;

+ (id)engineWithModel:(NSString *)modelName;
{
  Engine *engine = [[[self class] alloc] init];
  engine.model = modelName;
  return [engine autorelease];
}

@end
