//
//  KWSuiteConfigurationBase.m
//  Kiwi
//
//  Created by Adam Sharp on 14/12/2013.
//  Copyright (c) 2013 Allen Ding. All rights reserved.
//

#import "KWSuiteConfigurationBase.h"

@implementation KWSuiteConfigurationBase

+ (instancetype)defaultConfiguration
{
    static Class configClass;
    static KWSuiteConfigurationBase *defaultConfiguration;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        configClass = NSClassFromString(@"KWSuiteConfiguration");
        if (configClass && [configClass isSubclassOfClass:[self class]]) {
            defaultConfiguration = [configClass new];
        }
    });

    return defaultConfiguration;
}

- (void)configureSuite {}

- (void)setUp {
    [self configureSuite];

    if (self.beforeAllSpecsBlock) {
        self.beforeAllSpecsBlock();
    }
}

- (void)tearDown {
    if (self.afterAllSpecsBlock) {
        self.afterAllSpecsBlock();
    }
}

@end

void beforeAllSpecs(void (^block)(void)) {
    [[KWSuiteConfigurationBase defaultConfiguration] setBeforeAllSpecsBlock:block];
}

void afterAllSpecs(void (^block)(void)) {
    [[KWSuiteConfigurationBase defaultConfiguration] setAfterAllSpecsBlock:block];
}
