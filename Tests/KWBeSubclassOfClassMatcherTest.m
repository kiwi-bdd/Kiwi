//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWBeSubclassOfClassMatcherTest : SenTestCase

@end

@implementation KWBeSubclassOfClassMatcherTest

- (void)testItShouldHaveInformativeFailureMessageForShould
{
    id subject = [Cruiser cruiser];
    id matcher = [KWBeSubclassOfClassMatcher matcherWithSubject:subject];
    [matcher beSubclassOfClass:[Fighter class]];
    STAssertEqualObjects([matcher failureMessageForShould], @"expected subject to be subclass of Fighter, got Cruiser", @"failure message should match");
}

- (void)testItShouldHaveInformativeFailureMessageForShouldNot
{
    id subject = [Cruiser cruiser];
    id matcher = [KWBeSubclassOfClassMatcher matcherWithSubject:subject];
    [matcher beSubclassOfClass:[Fighter class]];
    STAssertEqualObjects([matcher failureMessageForShouldNot], @"expected subject not to be subclass of Fighter, got Cruiser", @"failure message should match");
}

@end

#endif // #if KW_TESTS_ENABLED
