//
//  KWContainStringMatcherTest.m
//  Kiwi
//
//  Created by Kristopher Johnson on 4/28/13.
//  Copyright (c) 2013 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWContainStringMatcherTest : SenTestCase

@end

@implementation KWContainStringMatcherTest

- (void)testItShouldHaveTheRightMatcherStrings {
    NSArray *matcherStrings = [KWContainStringMatcher matcherStrings];
    NSArray *expectedStrings = @[@"containString:", @"containString:options:", @"startWithString:", @"endWithString:"];
    STAssertEqualObjects([matcherStrings sortedArrayUsingSelector:@selector(compare:)],
                         [expectedStrings sortedArrayUsingSelector:@selector(compare:)],
                         @"expected specific matcher strings");
}

- (void)testItShouldHaveHumanReadableDescription {
    id matcher = [KWContainStringMatcher matcherWithSubject:@"test subject"];
    [matcher containString:@"foo"];
    STAssertEqualObjects([matcher description], @"contain substring \"foo\"", @"expected description to match");
}

- (void)testItShouldMatchSubstring {
    id subject = @"Transylvania";
    id matcher = [KWContainStringMatcher matcherWithSubject:subject];
    [matcher containString:@"sylvan"];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchIfNoSuchSubstring {
    id subject = @"Hot dog";
    id matcher = [KWContainStringMatcher matcherWithSubject:subject];
    [matcher containString:@"pup"];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldNotMatchIfCaseDoesNotMatch {
    id subject = @"Transylvania";
    id matcher = [KWContainStringMatcher matcherWithSubject:subject];
    [matcher containString:@"SYLVAN"];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldMatchSubstringWithCaseInsensitiveOption {
    id subject = @"Transylvania";
    id matcher = [KWContainStringMatcher matcherWithSubject:subject];
    [matcher containString:@"SYLVAN" options:NSCaseInsensitiveSearch];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldMatchPrefix {
    id subject = @"Hot dog";
    id matcher = [KWContainStringMatcher matcherWithSubject:subject];
    [matcher startWithString:@"Hot"];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchMissingPrefix {
    id subject = @"Hot dog";
    id matcher = [KWContainStringMatcher matcherWithSubject:subject];
    [matcher startWithString:@"ot"];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldMatchSuffix {
    id subject = @"Hot dog";
    id matcher = [KWContainStringMatcher matcherWithSubject:subject];
    [matcher endWithString:@"dog"];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchMissingSuffix {
    id subject = @"Hot dog";
    id matcher = [KWContainStringMatcher matcherWithSubject:subject];
    [matcher endWithString:@"do"];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

@end

#endif // #if KW_TESTS_ENABLED
