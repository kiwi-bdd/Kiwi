//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "KiwiTestConfiguration.h"
#import "KWExampleSuite.h"
#import "KWExampleSuiteBuilder.h"
#import "KWExample.h"

#if KW_TESTS_ENABLED

@interface KWExampleSuiteTest : XCTestCase

@end

@implementation KWExampleSuiteTest

- (void)testSelectorNamesAreUniqueForAnonymousExamplesInTheSameSuite {
    KWExampleSuiteBuilder *builder = [KWExampleSuiteBuilder new];
    KWExampleSuite *suite = [builder buildExampleSuite:^{
        [builder pushContextNodeWithCallSite:nil description:@"context"];
        [builder addItNodeWithCallSite:nil description:nil block:^{}];
        [builder addItNodeWithCallSite:nil description:nil block:^{}];
        [builder popContextNode];
    }];
    NSString *first = [suite.examples[0] selectorName];
    NSString *second = [suite.examples[1] selectorName];
    XCTAssertNotEqualObjects(first, second, @"expected unique selector names, got '%@'", first);
}

@end

#endif // #if KW_TESTS_ENABLED
