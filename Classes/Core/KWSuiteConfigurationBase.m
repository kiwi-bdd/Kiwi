//
//  KWSuiteConfigurationBase.m
//  Kiwi
//
//  Created by Adam Sharp on 14/12/2013.
//  Copyright (c) 2013 Allen Ding. All rights reserved.
//

#import "KWSuiteConfigurationBase.h"

#define INVOKE(block) if((block)) { (block)(); }

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
    INVOKE(self.beforeAllSpecsBlock);
}

- (void)tearDown {
    INVOKE(self.afterAllSpecsBlock);
}

#ifdef XCT_EXPORT
- (void)specDidStart:(XCTestRun *)testRun {
    INVOKE(self.beforeEachSpecBlock);
}

- (void)specDidStop:(XCTestRun *)testRun {
    INVOKE(self.afterEachSpecBlock);
}
#endif

@end

void beforeAllSpecs(void (^block)(void)) {
    [[KWSuiteConfigurationBase defaultConfiguration] setBeforeAllSpecsBlock:block];
}

void afterAllSpecs(void (^block)(void)) {
    [[KWSuiteConfigurationBase defaultConfiguration] setAfterAllSpecsBlock:block];
}

#ifdef XCT_EXPORT
void beforeEachSpec(void (^block)(void)) {
    [[KWSuiteConfigurationBase defaultConfiguration] setBeforeEachSpecBlock:block];
}

void afterEachSpec(void (^block)(void)) {
    [[KWSuiteConfigurationBase defaultConfiguration] setAfterEachSpecBlock:block];
}
#endif
