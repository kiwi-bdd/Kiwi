//
//  KWHamcrestDetector.m
//  Kiwi
//
//  Created by Paul Zabelin on 5/29/12.
//  Copyright (c) 2012 Blazing Cloud Inc. All rights reserved.
//

/** 
 *   NOTE: 
 *       To use Hamcrest library with Kiwi include Hamcrest headers first in your specs
 *       to use proper HCMatcher protocol definition instead of minimal version:
 *
 *       #import <OCHamcrestIOS/OCHamcrestIOS.h>
 *       #import "Kiwi.h"
 * 
 *       Also link OCHamcrestIOS framework first to the test binary, prior to Kiwi library. 
 *       XCode can set build order for the target in the build phases tab.
 *
 *       Failure to do so might cause endless recursion in -[HCBaseDescription appendDescriptionOf:] as it checks if
 *       a HCMatcher conforms to HCSelfDescribing protocol, which is not the case in minimal version of HCMatcher.
 */

#import <objc/runtime.h>
#import <Foundation/Foundation.h>

#import "KWHCMatcher.h"

@interface KWHamcrestDetector : NSObject
@end

@implementation KWHamcrestDetector

+ (void)initialize {
    Protocol *hamcrestSelfDescribingProtocol = NSProtocolFromString(@"HCSelfDescribing");
    if (hamcrestSelfDescribingProtocol) {
        NSAssert(protocol_conformsToProtocol(@protocol(HCMatcher), 
                                             hamcrestSelfDescribingProtocol), 
                 @"HCMatcher should be loaded from Hamcrest not Kiwi, \
                 please change link order to link Hamcrest prior to Kiwi");
    }
}

@end
