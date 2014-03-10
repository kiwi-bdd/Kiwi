//
//  KWConfigurationTestObserver.m
//  Kiwi
//
//  Created by Adam Sharp on 10/03/2014.
//  Copyright (c) 2014 Allen Ding. All rights reserved.
//

#import "KWConfigurationTestObserver.h"
#import "KWSuiteConfigurationBase.h"

@implementation KWConfigurationTestObserver

- (void)startObserving {
    [[KWSuiteConfigurationBase defaultConfiguration] setUp];
}

- (void)stopObserving {
    [[KWSuiteConfigurationBase defaultConfiguration] tearDown];
}

@end
