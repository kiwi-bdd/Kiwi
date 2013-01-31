//
//  KWGenericMatcherTest.m
//  Kiwi
//
//  Created by Luke Redpath on 24/01/2011.
//  Copyright 2011 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWGenericMatcherTest : SenTestCase

@end

@implementation KWGenericMatcherTest

- (void)testItShouldMatchObjectsThatMatchGenericMatchers
{
    id matcher = [KWGenericMatcher matcherWithSubject:@"Alpha Bravo"];
    [matcher match:hasPrefix(@"Alpha")];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchObjectsThatMatchGenericMatchers
{
    id matcher = [KWGenericMatcher matcherWithSubject:@"Charlie Bravo"];
    [matcher match:hasPrefix(@"Alpha")];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldHaveHumanReadableDescription
{
    id matcher = [KWGenericMatcher matcherWithSubject:nil];
    [matcher match:hasPrefix(@"Alpha")];
    STAssertEqualObjects(@"match a string with prefix 'Alpha'", [matcher description], @"description should match");
}

@end

#endif
