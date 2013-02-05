//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"
#import "KWIntercept.h"

#if KW_TESTS_ENABLED

@interface KWRealObjectSpyTest : SenTestCase

@end

@implementation KWRealObjectSpyTest

- (void)tearDown {
    KWClearStubsAndSpies();
}

- (void)testItShouldNotifySpies {
    Cruiser *cruiser = [Cruiser cruiser];
    TestSpy *spy = [TestSpy testSpy];
    [cruiser addMessageSpy:spy forMessagePattern:[KWMessagePattern messagePatternWithSelector:@selector(raiseShields)]];
    [cruiser raiseShields];
    STAssertTrue(spy.wasNotified, @"expected object to notify spies");
}

- (void)testItShouldRemoveSpies {
    Cruiser *cruiser = [Cruiser cruiser];
    TestSpy *spy = [TestSpy testSpy];
    KWMessagePattern *messagePattern = [KWMessagePattern messagePatternWithSelector:@selector(raiseShields)];
    [cruiser addMessageSpy:spy forMessagePattern:messagePattern];
    [cruiser removeMessageSpy:spy forMessagePattern:messagePattern];
    [cruiser raiseShields];
    STAssertFalse(spy.wasNotified, @"expected object to remove spies");
}

- (void)testItShouldNotifyMultipleSpiesWithDifferentMessagePatterns {
    Cruiser *cruiser = [Cruiser cruiser];
    TestSpy *spy1 = [TestSpy testSpy];
    TestSpy *spy2 = [TestSpy testSpy];
    KWMessagePattern *messagePattern1 = [KWMessagePattern messagePatternWithSelector:@selector(energyLevelInWarpCore:)];
    NSArray *argumentFilters = @[[KWValue valueWithUnsignedInt:2]];
    KWMessagePattern *messagePattern2 = [KWMessagePattern messagePatternWithSelector:@selector(energyLevelInWarpCore:) argumentFilters:argumentFilters];

    [cruiser addMessageSpy:spy1 forMessagePattern:messagePattern1];
    [cruiser addMessageSpy:spy2 forMessagePattern:messagePattern2];
    [cruiser energyLevelInWarpCore:2];

    STAssertTrue(spy1.wasNotified, @"expected object to notify spies");
    STAssertTrue(spy2.wasNotified, @"expected object to notify spies");
}

@end

#endif // #if KW_TESTS_ENABLED
