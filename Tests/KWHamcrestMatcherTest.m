//
//  KWHamcrestMatcherTest.m
//  Kiwi
//
//  Created by Luke Redpath on 24/01/2011.
//  Copyright 2011 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWHamcrestMatcherTest : SenTestCase

@end

@implementation KWHamcrestMatcherTest

- (void)testItShouldMatchObjectsThatMatchHamcrestMatchers
{
    id matcher = [KWHamcrestMatcher matcherWithSubject:@"Alpha Bravo"];
    [matcher match:hasPrefix(@"Alpha")];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchObjectsThatMatchHamcrestMatchers
{
    id matcher = [KWHamcrestMatcher matcherWithSubject:@"Charlie Bravo"];
    [matcher match:hasPrefix(@"Alpha")];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldHaveHumanReadableDescription
{
    id matcher = [KWHamcrestMatcher matcherWithSubject:nil];
    [matcher match:hasPrefix(@"Alpha")];
    STAssertEqualObjects(@"match a string with prefix 'Alpha'", [matcher description], @"description should match");
}

@end

#endif
