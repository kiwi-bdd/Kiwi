//
//  XCTestSuite+SuiteConfigurationAdditions.m
//  Kiwi
//
//  Created by Adam Sharp on 17/12/2013.
//  Copyright (c) 2013 Allen Ding. All rights reserved.
//

#import "TestSuiteConfigurationAdditions.h"
#import "KWSuiteConfigurationBase.h"

#import <objc/runtime.h>

@implementation KW_TEST_SUITE (SuiteConfigurationAdditions)

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self patchTestSuiteForBundlePathIMP];
    });
}

+ (void)patchTestSuiteForBundlePathIMP {
    Class c = object_getClass([self class]);
    SEL origSEL = @selector(testSuiteForBundlePath:);
    SEL newSEL = sel_registerName("__testSuiteForBundlePath:");

    Method origMethod = class_getClassMethod(c, origSEL);
    class_addMethod(c, newSEL, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));

    IMP kw_testSuiteForBundlePath = imp_implementationWithBlock(^(id _self, NSString *path){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        id suite = [_self performSelector:newSEL withObject:path];
#pragma clang diagnostic pop

        Method setUpMethod = class_getInstanceMethod([suite class], @selector(setUp));
        method_setImplementation(setUpMethod, imp_implementationWithBlock(^(id _self){
            [[KWSuiteConfigurationBase defaultConfiguration] setUp];
        }));

        Method tearDownMethod = class_getInstanceMethod([suite class], @selector(tearDown));
        method_setImplementation(tearDownMethod, imp_implementationWithBlock(^(id _self){
            [[KWSuiteConfigurationBase defaultConfiguration] tearDown];
        }));

        return suite;
    });
    method_setImplementation(origMethod, kw_testSuiteForBundlePath);
}

@end
