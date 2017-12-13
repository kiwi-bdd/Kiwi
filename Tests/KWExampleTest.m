//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "KiwiTestConfiguration.h"

#if KW_TESTS_ENABLED

@interface KWExampleTest : XCTestCase

@end

@implementation KWExampleTest

- (void)testItDoesntThrowExceptionWhenMakingExpectationsOnNilSubject {
    KWExample *example = [[KWExample alloc] initWithExampleNode:nil];
    void (^itNodeImitation)(void) = ^{
        [[(id)nil attachToVerifier:[example addMatchVerifierWithExpectationType:KWExpectationTypeShould callSite:nil]] equal:@"foo"];
        [[(id)nil attachToVerifier:[example addMatchVerifierWithExpectationType:KWExpectationTypeShouldNot callSite:nil]] containString:@"bar"];
    };
    XCTAssertNoThrow(itNodeImitation(), @"expected no exception");
}

@end

#endif // #if KW_TESTS_ENABLED
