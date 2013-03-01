//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWReceiveMatcherTest : SenTestCase

@end

@implementation KWReceiveMatcherTest

- (void)testItShouldHaveTheRightMatcherStrings {
    id matcherStrings = [KWReceiveMatcher matcherStrings];
    id expectedStrings = @[@"receive:",
                                                   @"receive:withCount:",
                                                   @"receive:withCountAtLeast:",
                                                   @"receive:withCountAtMost:",
                                                   @"receive:andReturn:",
                                                   @"receive:andReturn:withCount:",
                                                   @"receive:andReturn:withCountAtLeast:",
                                                   @"receive:andReturn:withCountAtMost:",
                                                   @"receiveMessagePattern:countType:count:",
                                                   @"receiveMessagePattern:andReturn:countType:count:"];
    STAssertEqualObjects([matcherStrings sortedArrayUsingSelector:@selector(compare:)],
                         [expectedStrings sortedArrayUsingSelector:@selector(compare:)],
                         @"expected specific matcher strings");
}

- (void)testItShouldMatchReceivedMessagesForReceive {
    id subject = [Cruiser cruiser];
    id matcher = [KWReceiveMatcher matcherWithSubject:subject];
    [matcher receive:@selector(raiseShields)];
    [subject raiseShields];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchNonReceivedMessagesForReceive {
    id subject = [Cruiser cruiser];
    id matcher = [KWReceiveMatcher matcherWithSubject:subject];
    [matcher receive:@selector(raiseShields)];
    [subject fighters];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldMatchReceivedMessagesForReceiveWithCount {
    id subject = [Cruiser cruiser];
    id matcher = [KWReceiveMatcher matcherWithSubject:subject];
    [matcher receive:@selector(raiseShields) withCount:2];
    [subject raiseShields];
    [subject raiseShields];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchNonReceivedMessagesForReceiveWithCount {
    id subject = [Cruiser cruiser];
    id matcher = [KWReceiveMatcher matcherWithSubject:subject];
    [matcher receive:@selector(raiseShields) withCount:2];
    [subject fighters];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldMatchReceivedMessagesForReceiveWithCountAtLeast {
    id subject = [Cruiser cruiser];
    id matcher = [KWReceiveMatcher matcherWithSubject:subject];
    [matcher receive:@selector(raiseShields) withCountAtLeast:2];
    [subject raiseShields];
    [subject raiseShields];
    [subject raiseShields];
    STAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchNonReceivedMessagesForReceiveWithCountAtLeast {
    id subject = [Cruiser cruiser];
    id matcher = [KWReceiveMatcher matcherWithSubject:subject];
    [matcher receive:@selector(raiseShields) withCountAtLeast:2];
    [subject fighters];
    STAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldStubForReceive {
    id subject  = [Cruiser cruiser];
    id matcher = [KWReceiveMatcher matcherWithSubject:subject];
    [matcher receive:@selector(crewComplement)];
    NSUInteger value = [subject crewComplement];
    STAssertTrue(value == 0, @"expected method to be stubbed");
}

- (void)testItShouldNotOverrideExistingStub {
    id subject  = [Cruiser cruiser];
    [subject stub:@selector(crewComplement) andReturn:[KWValue valueWithUnsignedInt:333]];
    id matcher = [KWReceiveMatcher matcherWithSubject:subject];
    [matcher receive:@selector(crewComplement)];
    NSUInteger value = [subject crewComplement];
    STAssertTrue(value == 333, @"expected receive not to override existing stub");
}

- (void)testItShouldStubForReceiveAndReturn {
    id subject = [Cruiser cruiser];
    id matcher = [KWReceiveMatcher matcherWithSubject:subject];
    [matcher receive:@selector(crewComplement) andReturn:[KWValue valueWithUnsignedInt:42]];
    NSUInteger value = [subject crewComplement];
    STAssertTrue([matcher evaluate], @"expected positive match");
    STAssertTrue(value == 42u, @"expected stubbed value");
}

- (void)testItShouldStubForReceiveAndReturnWithCount {
    id subject = [Cruiser cruiser];
    id matcher = [KWReceiveMatcher matcherWithSubject:subject];
    [matcher receive:@selector(crewComplement) andReturn:[KWValue valueWithUnsignedInt:42] withCount:2];
    [subject crewComplement];
    NSUInteger value = [subject crewComplement];
    STAssertTrue([matcher evaluate], @"expected positive match");
    STAssertTrue(value == 42u, @"expected stubbed value");
}

- (void)testItShouldStubForReceiveAndReturnWithCountAtLeast {
    id subject = [Cruiser cruiser];
    id matcher = [KWReceiveMatcher matcherWithSubject:subject];
    [matcher receive:@selector(crewComplement) andReturn:[KWValue valueWithUnsignedInt:42] withCountAtLeast:2];
    [subject crewComplement];
    [subject crewComplement];
    NSUInteger value = [subject crewComplement];
    STAssertTrue([matcher evaluate], @"expected positive match");
    STAssertTrue(value == 42u, @"expected stubbed value");
}

- (void)testItShouldStubForReceiveAndReturnWithCountAtMost {
    id subject = [Cruiser cruiser];
    id matcher = [KWReceiveMatcher matcherWithSubject:subject];
    [matcher receive:@selector(crewComplement) andReturn:[KWValue valueWithUnsignedInt:42] withCountAtMost:2];
    [subject crewComplement];
    NSUInteger value = [subject crewComplement];
    STAssertTrue([matcher evaluate], @"expected positive match");
    STAssertTrue(value == 42u, @"expected stubbed value");
}

@end

#endif // #if KW_TESTS_ENABLED
