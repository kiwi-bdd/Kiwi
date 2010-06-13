//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED && KW_BLOCKS_ENABLED

@interface KWExampleGroupBuilderTest : SenTestCase

@end

@implementation KWExampleGroupBuilderTest

- (void)testItShouldStartExampleGroups {
    STAssertNoThrow([[KWExampleGroupBuilder sharedExampleGroupBuilder] startExampleGroups], @"expected example group to be started");
    [[KWExampleGroupBuilder sharedExampleGroupBuilder] endExampleGroups];
    STAssertFalse([[KWExampleGroupBuilder sharedExampleGroupBuilder] isBuildingExampleGroup], @"example group builder must be clean for other tests to run cleanly");
}

- (void)testItShouldEndAndCreateExampleGroups {
    [[KWExampleGroupBuilder sharedExampleGroupBuilder] startExampleGroups];
    id exampleGroup = [[KWExampleGroupBuilder sharedExampleGroupBuilder] endExampleGroups];
    STAssertNotNil(exampleGroup, @"expected example group to be created");
    STAssertFalse([[KWExampleGroupBuilder sharedExampleGroupBuilder] isBuildingExampleGroup], @"example group builder must be clean for other tests to run cleanly");
}

- (void)testItShouldRaiseIfStartExampleGroupIsUnmatched {
    [[KWExampleGroupBuilder sharedExampleGroupBuilder] startExampleGroups];
    STAssertThrows([[KWExampleGroupBuilder sharedExampleGroupBuilder] startExampleGroups], @"expected raised exception");
    [[KWExampleGroupBuilder sharedExampleGroupBuilder] endExampleGroups];
    STAssertFalse([[KWExampleGroupBuilder sharedExampleGroupBuilder] isBuildingExampleGroup], @"example group builder must be clean for other tests to run cleanly");
}

- (void)testItShouldRaiseIfEndExampleGroupIsUnmatched {
    STAssertThrows([[KWExampleGroupBuilder sharedExampleGroupBuilder] endExampleGroups], @"expected raised exception");
    STAssertFalse([[KWExampleGroupBuilder sharedExampleGroupBuilder] isBuildingExampleGroup], @"example group builder must be clean for other tests to run cleanly");
}

- (void)testItShouldRaiseWhenEndingWithPushContextUnmatched {
    [[KWExampleGroupBuilder sharedExampleGroupBuilder] startExampleGroups];
    [[KWExampleGroupBuilder sharedExampleGroupBuilder] pushContextNodeWithCallSite:nil description:@"Cruiser"];
    STAssertThrows([[KWExampleGroupBuilder sharedExampleGroupBuilder] endExampleGroups], @"expected raised exception");
    [[KWExampleGroupBuilder sharedExampleGroupBuilder] popContextNode];
    [[KWExampleGroupBuilder sharedExampleGroupBuilder] endExampleGroups];
    STAssertFalse([[KWExampleGroupBuilder sharedExampleGroupBuilder] isBuildingExampleGroup], @"example group builder must be clean for other tests to run cleanly");
}

- (void)testItShouldRaiseWhenPopContextUnmatched {
    [[KWExampleGroupBuilder sharedExampleGroupBuilder] startExampleGroups];
    STAssertThrows([[KWExampleGroupBuilder sharedExampleGroupBuilder] popContextNode], @"expected raised exception");
    [[KWExampleGroupBuilder sharedExampleGroupBuilder] endExampleGroups];
    STAssertFalse([[KWExampleGroupBuilder sharedExampleGroupBuilder] isBuildingExampleGroup], @"example group builder must be clean for other tests to run cleanly");
}

@end

#endif // #if KW_TESTS_ENABLED && KW_BLOCKS_ENABLED
