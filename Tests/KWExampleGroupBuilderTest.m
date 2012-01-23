//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWExampleGroupBuilderTest : SenTestCase

@end

@implementation KWExampleGroupBuilderTest

- (void)testItShouldBuildExampleGroups {
    id exampleGroup = [[KWExampleGroupBuilder sharedExampleGroupBuilder] buildExampleGroups:^{}];
    STAssertNotNil(exampleGroup, @"expected example group to be created");
    STAssertFalse([[KWExampleGroupBuilder sharedExampleGroupBuilder] isBuildingExampleGroup], @"example group builder must be clean for other tests to run cleanly");
}

- (void)testItShouldRaiseWhenPopContextUnmatched {
    [[KWExampleGroupBuilder sharedExampleGroupBuilder] buildExampleGroups:^{
        STAssertThrows([[KWExampleGroupBuilder sharedExampleGroupBuilder] popContextNode], @"expected raised exception");
    }];
    STAssertFalse([[KWExampleGroupBuilder sharedExampleGroupBuilder] isBuildingExampleGroup], @"example group builder must be clean for other tests to run cleanly");
}

@end

#endif // #if KW_TESTS_ENABLED
