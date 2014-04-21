//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWBeKindOfClassArgumentMatcherTest : SenTestCase

@end

@implementation KWBeKindOfClassArgumentMatcherTest

- (void)testItShouldMatchKindOfClass {
    id subject = [Cruiser cruiser];
    id matcher = [KWBeKindOfClassArgumentMatcher matcherForClass:[SpaceShip class]];
    STAssertTrue([matcher matches:subject], @"expected positive match");
}

- (void)testItShouldNotMatchNonKindOfClass {
    id subject = [Cruiser cruiser];
    id matcher = [KWBeKindOfClassArgumentMatcher matcherForClass:[Fighter class]];
    STAssertFalse([matcher matches:subject], @"expected negative match");
}

- (void)testItShouldHaveHumanReadableDescription
{
    id matcher = [KWBeKindOfClassArgumentMatcher matcherForClass:[Fighter class]];
    STAssertEqualObjects([[Fighter class] description], [matcher description], @"description should match");
}

@end

#endif // #if KW_TESTS_ENABLED
