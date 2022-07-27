//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWReceiveMatcherTest : XCTestCase

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
                                                   @"receiveMessagePattern:andReturn:countType:count:",
                                                   @"receiveUnspecifiedCountOfMessagePattern:",
                                                   @"receiveUnspecifiedCountOfMessagePattern:andReturn:"];
    XCTAssertEqualObjects([matcherStrings sortedArrayUsingSelector:@selector(compare:)],
                          [expectedStrings sortedArrayUsingSelector:@selector(compare:)],
                          @"expected specific matcher strings");
}

- (void)testItShouldMatchReceivedMessagesForReceive {
    id subject = [Cruiser new];
    KWReceiveMatcher *matcher = [KWReceiveMatcher matcherWithSubject:subject];
    [matcher receive:@selector(raiseShields)];
    [subject raiseShields];
    XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldMatchMultipleReceivedMessagesForReceiveWhenAttachedToNegativeVerifier {
    id subject = [Cruiser new];
    KWReceiveMatcher *matcher = [KWReceiveMatcher matcherWithSubject:subject];
    matcher.willEvaluateAgainstNegativeExpectation = YES;
    [matcher receive:@selector(raiseShields)];
    [subject raiseShields];
    [subject raiseShields];
    XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchMultipleReceivedMessagesForReceiveWhenNotAttachedToNegativeVerifier {
    id subject = [Cruiser new];
    KWReceiveMatcher *matcher = [KWReceiveMatcher matcherWithSubject:subject];
    [matcher receive:@selector(raiseShields)];
    [matcher receive:@selector(raiseShields)];
    [subject raiseShields];
    [subject raiseShields];
    XCTAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldNotMatchNonReceivedMessagesForReceive {
    id subject = [Cruiser new];
    KWReceiveMatcher *matcher = [KWReceiveMatcher matcherWithSubject:subject];
    [matcher receive:@selector(raiseShields)];
    [subject fighters];
    XCTAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldMatchReceivedMessagesForReceiveWithCount {
    id subject = [Cruiser new];
    KWReceiveMatcher *matcher = [KWReceiveMatcher matcherWithSubject:subject];
    [matcher receive:@selector(raiseShields) withCount:2];
    [subject raiseShields];
    [subject raiseShields];
    XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchNonReceivedMessagesForReceiveWithCount {
    id subject = [Cruiser new];
    KWReceiveMatcher *matcher = [KWReceiveMatcher matcherWithSubject:subject];
    [matcher receive:@selector(raiseShields) withCount:2];
    [subject fighters];
    XCTAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldMatchReceivedMessagesForReceiveWithCountAtLeast {
    id subject = [Cruiser new];
    KWReceiveMatcher *matcher = [KWReceiveMatcher matcherWithSubject:subject];
    [matcher receive:@selector(raiseShields) withCountAtLeast:2];
    [subject raiseShields];
    [subject raiseShields];
    [subject raiseShields];
    XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchNonReceivedMessagesForReceiveWithCountAtLeast {
    id subject = [Cruiser new];
    KWReceiveMatcher *matcher = [KWReceiveMatcher matcherWithSubject:subject];
    [matcher receive:@selector(raiseShields) withCountAtLeast:2];
    [subject fighters];
    XCTAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldStubForReceive {
    id subject  = [Cruiser new];
    KWReceiveMatcher *matcher = [KWReceiveMatcher matcherWithSubject:subject];
    [matcher receive:@selector(crewComplement)];
    NSUInteger value = [subject crewComplement];
    XCTAssertTrue(value == 0, @"expected method to be stubbed");
}

- (void)testItShouldNotOverrideExistingStub {
    id subject  = [Cruiser new];
    [subject stub:@selector(crewComplement) andReturn:[KWValue valueWithUnsignedInt:333]];
    KWReceiveMatcher *matcher = [KWReceiveMatcher matcherWithSubject:subject];
    [matcher receive:@selector(crewComplement)];
    NSUInteger value = [subject crewComplement];
    XCTAssertTrue(value == 333, @"expected receive not to override existing stub");
}

- (void)testItShouldStubForReceiveAndReturn {
    id subject = [Cruiser new];
    KWReceiveMatcher *matcher = [KWReceiveMatcher matcherWithSubject:subject];
    [matcher receive:@selector(crewComplement) andReturn:[KWValue valueWithUnsignedInt:42]];
    NSUInteger value = [subject crewComplement];
    XCTAssertTrue([matcher evaluate], @"expected positive match");
    XCTAssertTrue(value == 42u, @"expected stubbed value");
}

- (void)testItShouldMatchMultipleReceivedMessagesForReceiveAndReturnWhenAttachedToNegativeVerifier {
    id subject = [Cruiser new];
    KWReceiveMatcher *matcher = [KWReceiveMatcher matcherWithSubject:subject];
    matcher.willEvaluateAgainstNegativeExpectation = YES;
    [matcher receive:@selector(crewComplement) andReturn:[KWValue valueWithBool:123]];
    [subject crewComplement];
    [subject crewComplement];
    XCTAssertTrue([matcher evaluate], @"expected positive match");
}

- (void)testItShouldNotMatchMultipleReceivedMessagesForReceiveAndReturnWhenNotAttachedToNegativeVerifier {
    id subject = [Cruiser new];
    KWReceiveMatcher *matcher = [KWReceiveMatcher matcherWithSubject:subject];
    [matcher receive:@selector(crewComplement) andReturn:[KWValue valueWithBool:123]];
    [subject crewComplement];
    [subject crewComplement];
    XCTAssertFalse([matcher evaluate], @"expected negative match");
}

- (void)testItShouldStubForReceiveAndReturnWithCount {
    id subject = [Cruiser new];
    KWReceiveMatcher *matcher = [KWReceiveMatcher matcherWithSubject:subject];
    [matcher receive:@selector(crewComplement) andReturn:[KWValue valueWithUnsignedInt:42] withCount:2];
    [subject crewComplement];
    NSUInteger value = [subject crewComplement];
    XCTAssertTrue([matcher evaluate], @"expected positive match");
    XCTAssertTrue(value == 42u, @"expected stubbed value");
}

- (void)testItShouldStubForReceiveAndReturnWithCountAtLeast {
    id subject = [Cruiser new];
    KWReceiveMatcher *matcher = [KWReceiveMatcher matcherWithSubject:subject];
    [matcher receive:@selector(crewComplement) andReturn:[KWValue valueWithUnsignedInt:42] withCountAtLeast:2];
    [subject crewComplement];
    [subject crewComplement];
    NSUInteger value = [subject crewComplement];
    XCTAssertTrue([matcher evaluate], @"expected positive match");
    XCTAssertTrue(value == 42u, @"expected stubbed value");
}

- (void)testItShouldStubForReceiveAndReturnWithCountAtMost {
    id subject = [Cruiser new];
    KWReceiveMatcher *matcher = [KWReceiveMatcher matcherWithSubject:subject];
    [matcher receive:@selector(crewComplement) andReturn:[KWValue valueWithUnsignedInt:42] withCountAtMost:2];
    [subject crewComplement];
    NSUInteger value = [subject crewComplement];
    XCTAssertTrue([matcher evaluate], @"expected positive match");
    XCTAssertTrue(value == 42u, @"expected stubbed value");
}

@end

#endif // #if KW_TESTS_ENABLED
