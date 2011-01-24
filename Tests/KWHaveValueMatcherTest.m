//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "NSInvocation+KiwiAdditions.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWHaveValueMatcherTest : SenTestCase

@end

@implementation KWHaveValueMatcherTest

- (void)testItShouldMatchValuesMatchUsingKeyValueCoding {
    id subject = [Cruiser cruiserWithCallsign:@"Alpha Bravo Zero"];
    id matcher = [KWHaveValueMatcher matcherWithSubject:subject];
    [matcher haveValue:@"Alpha Bravo Zero" forKey:@"callsign"];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchValuesMatchUsingKeyValueCoding {
    id subject = [Cruiser cruiserWithCallsign:@"Alpha Bravo Zero"];
    id matcher = [KWHaveValueMatcher matcherWithSubject:subject];
    [matcher haveValue:@"Alpha Bravo Charlie" forKey:@"callsign"];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldMatchValuesMatchUsingKeyValueCodingAndHamcrestMatcher {
    id subject = [Cruiser cruiserWithCallsign:@"Alpha Bravo Zero"];
    id matcher = [KWHaveValueMatcher matcherWithSubject:subject];
    [matcher haveValue:hasPrefix(@"Alpha") forKey:@"callsign"];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchValuesMatchUsingKeyValueCodingAndHamcrestMatcher {
    id subject = [Cruiser cruiserWithCallsign:@"Alpha Bravo Zero"];
    id matcher = [KWHaveValueMatcher matcherWithSubject:subject];
    [matcher haveValue:hasPrefix(@"Foxtrot") forKey:@"callsign"];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldMatchValuesThatExistUsingKeyValueCoding {
    id subject = [Cruiser cruiserWithCallsign:@"Alpha Bravo Zero"];
    id matcher = [KWHaveValueMatcher matcherWithSubject:subject];
    [matcher haveValueForKey:@"callsign"];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchValuesThatExistUsingKeyValueCoding {
    id subject = [Cruiser cruiserWithCallsign:nil];
    id matcher = [KWHaveValueMatcher matcherWithSubject:subject];
    [matcher haveValueForKey:@"callsign"];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

@end

#endif // #if KW_TESTS_ENABLED
