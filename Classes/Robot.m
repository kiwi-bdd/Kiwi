//
//  Robot.m
//  Kiwi
//
//  Created by Luke Redpath on 17/01/2011.
//  Copyright 2011 Allen Ding. All rights reserved.
//

#import "Robot.h"


@implementation Robot

+ (id)robot;
{
  return [[[self alloc] init] autorelease];
}

- (void)speak:(NSString *)message
{
  NSLog(@"Robot says %@", message);
}

- (void)speak:(NSString *)message afterDelay:(NSTimeInterval)delay whenDone:(void(^)(void))handler
{
    NSLog(@"Robot will say %@ after a %f second delay", message, delay);
}

@end
