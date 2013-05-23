//
//  SenTestSuite+KiwiAdditions.m
//  Kiwi
//
//  Created by Jerry Marino on 5/17/13.
//  Copyright (c) 2013 Allen Ding. All rights reserved.
//

#import "SenTestSuite+KiwiAdditions.h"
#import <SenTestingKit/SenTestProbe.h>
#import <SenTestingKit/SenTestSuite.h>
#import <objc/runtime.h>
#import "KWExampleGroupBuilder.h"
#import "KWCallSite.h"

@implementation SenTestSuite (KiwiAdditions)

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self patchTestSuiteForTestCaseClassIMP];
    });
}

// Patch this otherwise SenTestKit will start running all suites in test bundle
// even if they are empty
+ (void)patchTestSuiteForTestCaseClassIMP {
    Class c = object_getClass([SenTestSuite class]);
    SEL origSEL = @selector(testSuiteForTestCaseClass:);
    SEL newSEL = sel_registerName("__testSuiteForTestCaseClass:");

    Method origMethod = class_getClassMethod(c, origSEL);
    class_addMethod(c, newSEL, method_getImplementation(origMethod), method_getTypeEncoding(origMethod)) ;

    IMP focusedSuite = imp_implementationWithBlock(^(id _self, Class aClass){
        return ([[KWExampleGroupBuilder sharedExampleGroupBuilder] isFocused] && ![_self testSuiteClassHasFocus:aClass]) ? nil : (void *)[_self performSelector:@selector(__testSuiteForTestCaseClass:) withObject:aClass];
    });
    method_setImplementation(origMethod, focusedSuite);
}

+ (BOOL)testSuiteClassHasFocus:(Class)aClass {
    if (![aClass respondsToSelector:@selector(file)])
        return NO;

    KWCallSite *focusedCallSite = [[KWExampleGroupBuilder sharedExampleGroupBuilder] focusedCallSite];
    NSString *fullFilePathOfClass = [aClass performSelector:@selector(file)];
    NSRange rangeOfFileName = [fullFilePathOfClass rangeOfString:focusedCallSite.filename];
    return rangeOfFileName.length != 0;
}

@end
