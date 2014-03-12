//
//  KWConfigurationTestObserver.m
//  Kiwi
//
//  Created by Adam Sharp on 10/03/2014.
//  Copyright (c) 2014 Allen Ding. All rights reserved.
//

#import "KWConfigurationTestObserver.h"
#import "KWSpec.h"
#import "KWSuiteConfigurationBase.h"

@implementation KWConfigurationTestObserver

+ (void)load {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *observers = [NSString stringWithFormat:@"%@,%@", NSStringFromClass([XCTestLog class]),
                                                               NSStringFromClass([KWConfigurationTestObserver class])];
    [defaults registerDefaults:@{XCTestObserverClassKey: observers}];
}

- (void)startObserving {
    [super startObserving];
    [[KWSuiteConfigurationBase defaultConfiguration] setUp];
}

- (void)stopObserving {
    [super stopObserving];
    [[KWSuiteConfigurationBase defaultConfiguration] tearDown];
}

- (void)testSuiteDidStart:(XCTestRun *)testRun {
    if ([self testSuiteIsKiwiSpec:NSClassFromString(testRun.test.name)]) {
        [[KWSuiteConfigurationBase defaultConfiguration] specDidStart:testRun];
    }
}

- (void)testSuiteDidStop:(XCTestRun *)testRun {
    if ([self testSuiteIsKiwiSpec:NSClassFromString(testRun.test.name)]) {
        [[KWSuiteConfigurationBase defaultConfiguration] specDidStop:testRun];
    }
}

- (BOOL)testSuiteIsKiwiSpec:(Class)testSuiteClass {
    return ![testSuiteClass isEqual:[KWSpec class]] && [testSuiteClass isSubclassOfClass:[KWSpec class]];
}

@end
