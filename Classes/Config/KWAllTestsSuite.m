//
//  XCTestSuite+KWConfiguration.m
//  Kiwi
//
//  Created by Adam Sharp on 1/07/2014.
//  Copyright (c) 2014 Allen Ding. All rights reserved.
//

#import <XCTest/XCTestSuite.h>
#import <objc/runtime.h>
#import "KWSuiteConfigurationBase.h"

@interface _KWAllTestsSuite : XCTestSuite
@end

@implementation _KWAllTestsSuite

- (void)setUp {
    [super setUp];
    [[KWSuiteConfigurationBase defaultConfiguration] setUp];
}

- (void)tearDown {
    [[KWSuiteConfigurationBase defaultConfiguration] tearDown];
    [super tearDown];
}

@end

@interface XCTestSuite (KWConfiguration)
@end

@implementation XCTestSuite (KWConfiguration)

+ (void)load {
    Method testSuiteWithName = class_getClassMethod(self, @selector(testSuiteWithName:));
    Method kiwi_testSuiteWithName = class_getClassMethod(self, @selector(kiwi_testSuiteWithName:));
    method_exchangeImplementations(testSuiteWithName, kiwi_testSuiteWithName);
    
    Method kiwi_testSuiteForTestCaseWithName = class_getClassMethod(self, @selector(kiwi_testSuiteForTestCaseWithName:));
    Method testSuiteForTestCaseWithName = class_getClassMethod(self, @selector(testSuiteForTestCaseWithName:));

    method_exchangeImplementations(kiwi_testSuiteForTestCaseWithName, testSuiteForTestCaseWithName);
    
}

+ (id)kiwi_testSuiteWithName:(NSString *)aName {
    id suite = [self kiwi_testSuiteWithName:aName];
    if ([aName isEqualToString:@"All tests"]) {
        if ([suite isMemberOfClass:[XCTestSuite class]]) {
            object_setClass(suite, [_KWAllTestsSuite class]);
        }
    }
    return suite;
}

+ (instancetype)kiwi_testSuiteForTestCaseWithName:(NSString *)testCaseName {

    id suite = [self kiwi_testSuiteForTestCaseWithName:testCaseName];

    // If Xcode was able to find valid suite
    // Then it's probably not Kiwi Test Suite -_-
    if ([[suite tests] count]) {
        return suite;
    }

    // TODO : make suites search to be more efficient
    // Let's search test suite in the all suites
    XCTestSuite *allTestsSuite = [XCTestSuite defaultTestSuite];

    // We don't want to search for non-kiwi tests here
    if (![allTestsSuite isKindOfClass:[_KWAllTestsSuite class]]) {
        return suite;
    }

    XCTestSuite * allTestsInBundleSuite = [[allTestsSuite tests] firstObject];
    NSArray *specs = [allTestsInBundleSuite tests];

    // test case name have format
    // SpecName/TestName
    NSArray *specAndTestNameToSearch = [testCaseName componentsSeparatedByString:@"/"];
    if (![specAndTestNameToSearch count] == 2) {
        return suite;
    }
    NSString *specNameToSearch = specAndTestNameToSearch[0];
    NSString *testNameToSearch = specAndTestNameToSearch[1];

    for (XCTestSuite *spec in specs) {
        if (![spec.name isEqualToString:specNameToSearch]) {
            continue;
        }

        for (XCTest *test in [spec tests]) {
            if ([test.name rangeOfString:testNameToSearch].location == NSNotFound) {
                continue;
            }

            XCTestSuite *nextSuite = [[XCTestSuite alloc] initWithName:spec.name];
            [nextSuite addTest:test];

            if ([nextSuite isMemberOfClass:[XCTestSuite class]]) {
                object_setClass(nextSuite, [_KWAllTestsSuite class]);
            }
            return nextSuite;
        }

    }
    return suite;
}


@end
