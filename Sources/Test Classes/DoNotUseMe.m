//
//  DoNotUseMe.m
//  Kiwi
//
//  Created by Victor Ilyukevich on 9/28/15.
//  Copyright © 2015 Allen Ding. All rights reserved.
//

#import "DoNotUseMe.h"

@implementation DoNotUseMe

+ (void)initialize
{
    [NSException raise:@"DoNotUseMe" format:@"I'm not supposed to be initialized"];
}

@end
