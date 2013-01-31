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

- (void)testItShouldMatchValuesUsingKeyValueCoding {
    id subject = [Cruiser cruiserWithCallsign:@"Alpha Bravo Zero"];
    id matcher = [KWHaveValueMatcher matcherWithSubject:subject];
    [matcher haveValue:@"Alpha Bravo Zero" forKey:@"callsign"];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchValuesUsingKeyValueCoding {
    id subject = [Cruiser cruiserWithCallsign:@"Alpha Bravo Zero"];
    id matcher = [KWHaveValueMatcher matcherWithSubject:subject];
    [matcher haveValue:@"Alpha Bravo Charlie" forKey:@"callsign"];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldMatchValuesUsingKeyPaths {
    Cruiser *subject = [Cruiser cruiserWithCallsign:@"Alpha Bravo Zero"];
    subject.engine = [Engine engineWithModel:@"Super Rocket Engine"];
    id matcher = [KWHaveValueMatcher matcherWithSubject:subject];
    [matcher haveValue:@"Super Rocket Engine" forKeyPath:@"engine.model"];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchValuesUsingKeyPaths {
    Cruiser *subject = [Cruiser cruiserWithCallsign:@"Alpha Bravo Zero"];
    subject.engine = [Engine engineWithModel:@"Super Rocket Engine"];
    id matcher = [KWHaveValueMatcher matcherWithSubject:subject];
    [matcher haveValue:@"Rubbish Rocket Engine" forKeyPath:@"engine.model"];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldMatchValuesMatchUsingKeyValueCodingAndGenericMatcher {
    id subject = [Cruiser cruiserWithCallsign:@"Alpha Bravo Zero"];
    id matcher = [KWHaveValueMatcher matcherWithSubject:subject];
    [matcher haveValue:hasPrefix(@"Alpha") forKey:@"callsign"];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchValuesMatchUsingKeyValueCodingAndGenericMatcher {
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

- (void)testItShouldMatchValuesThatExistUsingKeyValueCodingAndKeyPaths {
    Cruiser *subject = [Cruiser cruiserWithCallsign:@"Alpha Bravo Zero"];
    subject.engine = [Engine engineWithModel:@"Super Rocket Engine"];
    id matcher = [KWHaveValueMatcher matcherWithSubject:subject];
    [matcher haveValueForKeyPath:@"engine.model"];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchValuesThatExistUsingKeyValueCodingAndKeyPaths {
    id subject = [Cruiser cruiserWithCallsign:nil];
    id matcher = [KWHaveValueMatcher matcherWithSubject:subject];
    [matcher haveValueForKeyPath:@"engine.model"];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldHaveHumanReadableDescription
{
  id matcher = [KWHaveValueMatcher matcherWithSubject:nil];

  [matcher haveValueForKey:@"callsign"];
  STAssertEqualObjects(@"have value for key \"callsign\"", [matcher description], @"description should match");

  [matcher haveValue:@"alpha" forKey:@"callsign"];
  STAssertEqualObjects(@"have value \"alpha\" for key \"callsign\"", [matcher description], @"description should match");

  matcher = [KWHaveValueMatcher matcherWithSubject:nil];

  [matcher haveValueForKeyPath:@"engine.model"];
  STAssertEqualObjects(@"have value for keypath \"engine.model\"", [matcher description], @"description should match");

  [matcher haveValue:@"version-one" forKeyPath:@"engine.model"];
  STAssertEqualObjects(@"have value \"version-one\" for keypath \"engine.model\"", [matcher description], @"description should match");
}

@end

#endif // #if KW_TESTS_ENABLED
