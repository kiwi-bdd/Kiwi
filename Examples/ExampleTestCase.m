//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface ExampleTestCase : KWTestCase

@end

@implementation ExampleTestCase

- (void)itShouldVerifyExistence {
    id subject = [Cruiser cruiser];
    [subject shouldNotBeNil];
}

- (void)itShouldVerifyCloseness {
    id subject = theValue(42);
    [[subject should] beWithin:theValue(2) of:theValue(40)];

    subject = theValue(42.00001);
    [[subject should] equal:42.0 withDelta:0.1];
}

- (void)itShouldVerifyEquality {
    id subject = @"foo";
    id otherSubject = @"foo";
    [[subject should] equal:otherSubject];

    otherSubject = @"bar";
    [[subject shouldNot] equal:otherSubject];
}

- (void)itShouldVerifyGreaterValues {
    id subject = theValue(42);
    [[subject should] beGreaterThan:theValue(41)];
    [[subject should] beGreaterThanOrEqualTo:theValue(42)];
}

- (void)itShouldVerifyLesserValues {
    id subject = theValue(42);
    [[subject should] beLessThan:theValue(43)];
    [[subject should] beLessThanOrEqualTo:theValue(43)];
}

- (void)itShouldVerifyIdentity {
    id subject = [Cruiser cruiser];
    [[subject should] beIdenticalTo:subject];
}

- (void)itShouldVerifyIntervalMembership {
    id subject = theValue(42);
    [[subject should] beBetween:theValue(40) and:theValue(43)];
}

- (void)itShouldVerifyTruthValues {
    id subject = theValue(YES);
    [[subject should] beTrue];

    subject = theValue(NO);
    [[subject should] beFalse];
}

- (void)itShouldVerifyZero {
    id subject = theValue(0);
    [[subject should] beZero];
}

- (void)itShouldVerifyProtocolConformance {
    id subject = [Cruiser cruiser];
    [[subject should] conformToProtocol:@protocol(JumpCapable)];
}

- (void)itShouldVerifyKindsOfClasses {
    id subject = [Cruiser cruiser];
    [[subject should] beKindOfClass:[SpaceShip class]];
}

- (void)itShouldVerifyClassMembership {
    id subject = [Cruiser cruiser];
    [[subject should] beMemberOfClass:[Cruiser class]];
}

- (void)itShouldVerifyEmptyCollections {
    id subject = [NSArray arrayWithObjects:@"foot", @"ball", nil];
    [[subject shouldNot] beEmpty];
}

- (void)itShouldVerifyElementContainment {
    id subject = [NSArray arrayWithObjects:@"dog", @"cat", @"tiger", @"liger", nil];
    [[subject should] contain:@"liger"];
    [[subject should] containObjects:@"liger", @"tiger", nil];
}

- (void)itShouldVerifyCollectionCounts {
    id subject = [NSArray arrayWithObjects:@"dog", @"cat", @"tiger", @"liger", nil];
    [[subject should] haveCountOf:4];
    [[subject should] haveCountOfAtLeast:3];
    [[subject should] haveCountOfAtMost:5];
}

- (void)itShouldVerifyCollectionCountsWithInvocationKeys {
    id subject = [Cruiser cruiser];
    [subject setFighters:[NSArray arrayWithObjects:[Fighter fighterWithCallsign:@"Viper 1"],
                                                   [Fighter fighterWithCallsign:@"Viper 2"],
                                                   [Fighter fighterWithCallsign:@"Mamba 1"], nil]];
    [[[subject should] have:2] fightersInSquadron:@"Viper"];
}

- (void)itShouldVerifyRespondsToSelector {
    id subject = [Cruiser cruiser];
    [[subject should] respondToSelector:@selector(raiseShields)];
}

- (void)itShouldVerifyRaisedExceptions {
    id subject = [Cruiser cruiser];
    [[subject should] raiseWhenSent:@selector(raise)];
    [[subject should] raiseWithName:@"CruiserException" whenSent:@selector(raise)];
    [[subject should] raiseWithReason:@"-[Cruiser raise]" whenSent:@selector(raise)];
    [[subject should] raiseWithName:@"CruiserException" reason:@"-[Cruiser raise]" whenSent:@selector(raise)];
}

- (void)itShouldVerifyBlockRaisedExceptions {
    id subject = [Cruiser cruiser];
    [[theBlock(^{ [subject raise]; }) should] raise];
    [[theBlock(^{ [subject raise]; }) should] raiseWithName:@"CruiserException"];
    [[theBlock(^{ [subject raise]; }) should] raiseWithReason:@"-[Cruiser raise]"];
    [[theBlock(^{ [subject raise]; }) should] raiseWithName:@"CruiserException" reason:@"-[Cruiser raise]"];

    NSArray *foo = [NSArray array];
    [[theBlock(^{ [foo objectAtIndex:0]; }) should] raiseWithName:NSRangeException];
}

- (void)itShouldVerifyReceivedMessages {
    id subject = [Cruiser cruiser];
    [[subject should] receive:@selector(raiseShields) withCountAtLeast:1];
    [subject raiseShields];

    subject = [Cruiser cruiser];
    [[[subject should] receiveAndReturn:theValue(42) withCountAtLeast:2] crewComplement];
    [subject crewComplement];
    NSUInteger complement = [subject crewComplement];
    [[theValue(complement) should] equal:theValue(42)];

    subject = [Cruiser cruiser];
    [[subject should] receive:@selector(energyLevelInWarpCore:) andReturn:theValue(1.01f) withCount:2 arguments:theValue(2)];
    [subject energyLevelInWarpCore:2];
    float energyLevel = [subject energyLevelInWarpCore:2];
    [[theValue(energyLevel) should] equal:theValue(1.01f)];
}

- (void)itShouldVerifyReceivedMessagesWithAnyArgument {
    id subject = [Cruiser cruiser];
    [[subject should] receive:@selector(energyLevelInWarpCore:) andReturn:theValue(1.01f) withCount:2 arguments:any()];
    [subject energyLevelInWarpCore:2];
    float energyLevel = [subject energyLevelInWarpCore:2];
    [[theValue(energyLevel) should] equal:theValue(1.01f)];
}

- (void)itShouldAllowExpectationsArgumentsToBeHamcrestMatchersForFuzzyMatching
{
    id subject = [Robot robot];
    [[[subject should] receive] speak:hasPrefix(@"Hello")];
    [subject speak:@"Hello world"];
}

- (void)itShouldMakeStubbedInstanceObjectsTransparent {
    id subject = [Cruiser cruiser];
    [subject stub:@selector(raiseShields) andReturn:theValue(YES)];
    [[[subject class] should] beIdenticalTo:[Cruiser class]];
    [[[subject superclass] should] beIdenticalTo:[Cruiser superclass]];
}

- (void)itShouldMakeStubbedClassObjectsTransparent {
    id subject = [Cruiser class];
    [subject stub:@selector(classification) andReturn:@"Animal"];
    [[[subject class] should] beIdenticalTo:[Cruiser class]];
    [[[subject superclass] should] beIdenticalTo:[Cruiser superclass]];
}

- (void)itShouldHandleAMixOfReceiveAndEqualExpectations {
    id subject = [Cruiser mock];
    //id subject = [Cruiser cruiser];
    [[subject should] receive:@selector(raiseShields) andReturn:theValue(NO)];
    [[subject should] receive:@selector(isEqual:) andReturn:theValue(YES)];
    [subject raiseShields];
    [[subject should] equal:@"terry"];
}

- (void)itShouldHandleStubbedAllocAndInitInMocks {
    id subject = [Cruiser mock];
    id otherSubject = [Cruiser mock];
    [Cruiser stub:@selector(alloc) andReturn:subject];
    [subject stub:@selector(init) andReturn:otherSubject];
    id actual = [[[Cruiser alloc] init] autorelease];
    [[actual should] beIdenticalTo:otherSubject];
}

- (void)itShouldHandleStubbedAllocAndInitInPartialMocks {
    id subject = [Cruiser cruiser];
    id otherSubject = [Cruiser cruiser];
    [Cruiser stub:@selector(alloc) andReturn:subject];
    [subject stub:@selector(init) andReturn:otherSubject];
    id actual = [[[Cruiser alloc] init] autorelease];
    [[actual should] beIdenticalTo:otherSubject];
}

- (void)itShouldHandleStubbedAllocAndCustomInitInMocks {
    id subject = [Cruiser mock];
    id otherSubject = [Cruiser mock];
    [Cruiser stub:@selector(alloc) andReturn:subject];
    [subject stub:@selector(initWithCallsign:) andReturn:otherSubject];
    id actual = [[[Cruiser alloc] initWithCallsign:@"foo"] autorelease];
    [[actual should] beIdenticalTo:otherSubject];
}

- (void)itShouldHandleStubbedAllocAndCustomInitInPartialMocks {
    id subject = [Cruiser cruiser];
    id otherSubject = [Cruiser cruiser];
    [Cruiser stub:@selector(alloc) andReturn:subject];
    [subject stub:@selector(initWithCallsign:) andReturn:otherSubject];
    id actual = [[[Cruiser alloc] initWithCallsign:@"foo"] autorelease];
    [[actual should] beIdenticalTo:otherSubject];
}

@end

#endif // #if KW_TESTS_ENABLED
