//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWExampleSuiteBuilderTest : XCTestCase

@end

@implementation KWExampleSuiteBuilderTest

- (void)testItShouldBuildExampleSuite {
    id exampleSuite = [[KWExampleSuiteBuilder sharedExampleSuiteBuilder] buildExampleSuite:^{}];
    XCTAssertNotNil(exampleSuite, @"expected example suite to be created");
    XCTAssertFalse([[KWExampleSuiteBuilder sharedExampleSuiteBuilder] isBuildingExampleSuite], @"example suite builder must be clean for other tests to run cleanly");
}

- (void)testItShouldRaiseWhenPopContextUnmatched {
    [[KWExampleSuiteBuilder sharedExampleSuiteBuilder] buildExampleSuite:^{
        XCTAssertThrows([[KWExampleSuiteBuilder sharedExampleSuiteBuilder] popContextNode], @"expected raised exception");
    }];
    XCTAssertFalse([[KWExampleSuiteBuilder sharedExampleSuiteBuilder] isBuildingExampleSuite], @"example suite builder must be clean for other tests to run cleanly");
}

@end

#endif // #if KW_TESTS_ENABLED
