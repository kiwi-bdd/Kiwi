//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWDeviceInfo.h"

#if TARGET_IPHONE_SIMULATOR

#import <UIKit/UIKit.h>

#endif // #if TARGET_IPHONE_SIMULATOR

@implementation KWDeviceInfo

#pragma mark -
#pragma mark Getting the Device Type

+ (BOOL)isSimulator {
#if TARGET_IPHONE_SIMULATOR
    NSString *model = [[UIDevice currentDevice] model];
    return [model hasSuffix:@" Simulator"];
#else
    return NO;
#endif // #if TARGET_IPHONE_SIMULATOR
}

+ (BOOL)isPhysical {
    return ![self isSimulator];
}

@end
