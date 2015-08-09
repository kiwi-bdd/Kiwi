//
//  KWSymbolicator.h
//  Kiwi
//
//  Created by Jerry Marino on 4/28/13.
//  Copyright (c) 2013 Allen Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KWSymbolicator.h"
#import "KWCallSite.h"

long kwCallerAddress(void);

@interface KWCallSite (KWSymbolication)

+ (KWCallSite *)callSiteWithCallerAddress:(long)address;

@end
