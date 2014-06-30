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

@interface KWContainStringMatcherTest : XCTestCase

@end

@implementation KWContainStringMatcherTest

- (void)testItShouldHaveTheRightMatcherStrings {
    NSArray *matcherStrings = [KWContainStringMatcher matcherStrings];
    NSArray *expectedStrings = @[@"containString:", @"containString:options:", @"startWithString:", @"endWithString:"];
    XCTAssertEqualObjects([matcherStrings sortedArrayUsingSelector:@selector(compare:)],
                          [expectedStrings sortedArrayUsingSelector:@selector(compare:)],
                          @"expected specific matcher strings");
}

- (void)testItShouldHaveHumanReadableDescription {
    KWContainStringMatcher *matcher = [KWContainStringMatcher matcherWithSubject:@"test subject"];
    [matcher containString:@"foo"];
    XCTAssertEqualObjects([matcher description], @"contain substring \"foo\"", @"expected description to match");
}

- (void)testItShouldMatchSubstring {
    id subject = @"Transylvania";
    KWContainStringMatcher *matcher = [KWContainStringMatcher matcherWithSubject:subject];
    [matcher containString:@"sylvan"];
    XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchIfNoSuchSubstring {
    id subject = @"Hot dog";
    KWContainStringMatcher *matcher = [KWContainStringMatcher matcherWithSubject:subject];
    [matcher containString:@"pup"];
    XCTAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldNotMatchIfCaseDoesNotMatch {
    id subject = @"Transylvania";
    KWContainStringMatcher *matcher = [KWContainStringMatcher matcherWithSubject:subject];
    [matcher containString:@"SYLVAN"];
    XCTAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldMatchSubstringWithCaseInsensitiveOption {
    id subject = @"Transylvania";
    KWContainStringMatcher *matcher = [KWContainStringMatcher matcherWithSubject:subject];
    [matcher containString:@"SYLVAN" options:NSCaseInsensitiveSearch];
    XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldMatchPrefix {
    id subject = @"Hot dog";
    KWContainStringMatcher *matcher = [KWContainStringMatcher matcherWithSubject:subject];
    [matcher startWithString:@"Hot"];
    XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchMissingPrefix {
    id subject = @"Hot dog";
    KWContainStringMatcher *matcher = [KWContainStringMatcher matcherWithSubject:subject];
    [matcher startWithString:@"ot"];
    XCTAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldMatchSuffix {
    id subject = @"Hot dog";
    KWContainStringMatcher *matcher = [KWContainStringMatcher matcherWithSubject:subject];
    [matcher endWithString:@"dog"];
    XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchMissingSuffix {
    id subject = @"Hot dog";
    KWContainStringMatcher *matcher = [KWContainStringMatcher matcherWithSubject:subject];
    [matcher endWithString:@"do"];
    XCTAssertFalse([matcher evaluate], @"expected negative match");
}

@end

#endif // #if KW_TESTS_ENABLED
