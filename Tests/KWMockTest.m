//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"
#import "KWIntercept.h"
#import "NSMethodSignature+KiwiAdditions.h"

#if KW_TESTS_ENABLED

@interface KWMockTest : SenTestCase

@end

@implementation KWMockTest

- (void)tearDown {
    KWClearStubsAndSpies();
}

- (void)testItShouldInitializeForAClassWithANameAsANullObject {
    id mockedClass = [Cruiser class];
    id name = @"Car mock";
    id mock = [KWMock nullMockWithName:name forClass:mockedClass];
    STAssertNotNil(mock, @"expected a mock object to be initialized");
    STAssertEqualObjects([mock mockedClass], mockedClass, @"expected the mockedClass property to be set");
    STAssertTrue([mock isNullMock], @"expected the isNullObject property to be set");
    STAssertEqualObjects([mock mockName], @"Car mock", @"expected class mock to have the correct mockName");
}

- (void)testItShouldInitializeForAProtocolWithANameAsANullObject {
    id mockedProtocol = @protocol(JumpCapable);
    id name = @"JumpCapable mock";
    id mock = [KWMock nullMockWithName:name forProtocol:mockedProtocol];
    STAssertNotNil(mock, @"expected a mock object to be initialized");
    STAssertEqualObjects([mock mockedProtocol], mockedProtocol, @"expected the mockedProtocol property to be set");
    STAssertTrue([mock isNullMock], @"expected the isNullObject property to be set");
    STAssertEqualObjects([mock mockName], @"JumpCapable mock", @"expected class mock to have the correct mockName");
}

- (void)testItShouldInitializeAPartialMockForAClass {
    id mockedObject = [[Cruiser alloc] init];
    id name = @"Cruiser mock";
    id mock = [KWMock partialMockWithName:name forObject:mockedObject];
    STAssertNotNil(mock, @"expected a mock object to be initialized");
    STAssertEqualObjects([mock mockedObject], mockedObject, @"expected the mockedClass property to be set");
    STAssertTrue([mock isPartialMock], @"expected the isPartialMock property to be set");
}

- (void)testItShouldPassThroughAMessageToTheMockedObjectAsAPartialMock {
    id callsign = @"Object Callsign";
    id mockedObject = [[Cruiser alloc] initWithCallsign:callsign];
    id mock = [KWMock partialMockForObject:mockedObject];
    id returnedCallsign = [mock callsign];
    STAssertEqualObjects(returnedCallsign, callsign, @"expected the partial mock to pass through a message to the object");
}

//- (void)testItShouldRaiseWhenReceivingUnexpectedMessageAsAMock {
//    id mock = [KWMock mockForClass:[Cruiser class]];
//    STAssertThrows([mock objectAtIndex:0], @"expected mock to raise exception");
//}

- (void)testItShouldNotRaiseWhenReceivingUnexpectedMessageAsANullMock {
    id mock = [Cruiser nullMock];
    STAssertNoThrow([mock raiseShields], @"expected null mock not to raise when receiving unexpected message");
}

- (void)testItShouldStubWithASelector {
    id mock = [Cruiser mock];
    [mock stub:@selector(raiseShields)];
    STAssertEquals([mock raiseShields], NO, @"expected method to be stubbed with the correct value");
}

- (void)testItShouldStubTheNameMethodOnAClassMock {
    id mock = [Galaxy mock];
    [[mock stubAndReturn:@"fake galaxy mockName"] name];
    STAssertEqualObjects([mock name], @"fake galaxy mockName", @"expected mockName property to return the stub value");
}

- (void)testItShouldBeOkToStubOnSingletons {
    TestSpy *firstSpy = [TestSpy testSpy];
    KWMessagePattern *firstMessagePattern = [KWMessagePattern messagePatternWithSelector:@selector(notifyEarth)];
    [[Galaxy sharedGalaxy] addMessageSpy:firstSpy forMessagePattern:firstMessagePattern];
    
    KWClearStubsAndSpies();
    
    TestSpy *secondSpy = [TestSpy testSpy];
    KWMessagePattern *secondMessagePattern = [KWMessagePattern messagePatternWithSelector:@selector(notifyPlanet:)];
    [[Galaxy sharedGalaxy] addMessageSpy:secondSpy forMessagePattern:secondMessagePattern];
    
    [[Galaxy sharedGalaxy] notifyEarth];
    
    STAssertTrue(secondSpy.wasNotified, @"expected first spy to never be called");
}

- (void)testItShouldStubWithASelectorAndReturnValue {
    id mock = [Cruiser mock];
    [mock stub:@selector(crewComplement) andReturn:[KWValue valueWithUnsignedInt:42]];
    STAssertEquals([mock crewComplement], 42u, @"expected method to be stubbed with the correct value");
}

- (void)testItShouldStubWithASelectorReturnValueAndArguments {
    id mock = [Cruiser nullMock];
    [mock stub:@selector(energyLevelInWarpCore:) andReturn:theValue(30.0f) withArguments:theValue(3)];
    STAssertEquals([mock energyLevelInWarpCore:3], 30.0f, @"expected method with arguments to be stubbed with the correct value");
    STAssertTrue([mock energyLevelInWarpCore:2] != 30.0f, @"expected method with arguments not to be stubbed");
}

- (void)testItShouldStubWithASelectorReturnValueAndAnyArguments {
    id mock = [Cruiser nullMock];
    [mock stub:@selector(energyLevelInWarpCore:) andReturn:theValue(30.0f) withArguments:any()];
    STAssertEquals([mock energyLevelInWarpCore:3], 30.0f, @"expected method with any() arguments to be stubbed");
    STAssertEquals([mock energyLevelInWarpCore:2], 30.0f, @"expected method with any() arguments to be stubbed");
}

- (void)testItShouldStubWithAMessage {
    id mock = [Cruiser mock];
    STAssertNoThrow([[mock stub] energyLevelInWarpCore:3], @"expected mock to stub message");
    float ratio = [mock energyLevelInWarpCore:3];
    STAssertEquals(ratio, 0.0f, @"expected mock to have message stubbed");
}

- (void)testItShouldStubWithAReturnValueAndMessage {
    id mock = [Cruiser mock];
    STAssertNoThrow([[mock stubAndReturn:[KWValue valueWithFloat:42.0f]] energyLevelInWarpCore:3], @"expected mock to stub message");
    float ratio = [mock energyLevelInWarpCore:3];
    STAssertEquals(ratio, 42.0f, @"expected mock to have message stubbed");
}

- (void)testItShouldStubWithDifferentReturnValuesAndMessage {
    id mock = [Cruiser mock];
    STAssertNoThrow([[mock stubAndReturn:[KWValue valueWithFloat:42.0f] times:[KWValue valueWithInt:2] afterThatReturn:[KWValue valueWithFloat:43.0f]] energyLevelInWarpCore:3], @"expected mock to stub message");
    float firstRatio = [mock energyLevelInWarpCore:3];
    STAssertEquals(firstRatio, 42.0f, @"expected mock to have message stubbed");
    float secondRatio = [mock energyLevelInWarpCore:3];
    STAssertEquals(secondRatio, 42.0f, @"expected mock to have message stubbed");
    float thirdRatio = [mock energyLevelInWarpCore:3];
    STAssertEquals(thirdRatio, 43.0f, @"expected mock to have message stubbed and changed return value");
}

- (void)testItShouldClearStubbedMethods {
    id mock = [Cruiser mock];
    [mock stub:@selector(callsign) andReturn:@"Executor"];
    [mock clearStubs];
    STAssertNil([mock callsign], @"expected method stub to be cleared");
}

- (void)testItShouldStubWhitelistedMethods {
    id mock = [Cruiser mock];
    [mock stub:@selector(isEqual:) andReturn:[KWValue valueWithBool:YES]];
    [mock stub:@selector(hash) andReturn:[KWValue valueWithUnsignedInt:4242]];
    [mock stub:@selector(description) andReturn:@"king rat"];
    [mock stub:@selector(copy) andReturn:@"bacon"];
    STAssertTrue([mock isEqual:@"foobar"], @"expected method to be stubbed");
    STAssertEquals([mock hash], 4242u, @"expected method to be stubbed");
    STAssertEqualObjects([mock description], @"king rat", @"expected method to be stubbed");
    STAssertEqualObjects([mock copy], @"bacon", @"expected method to be stubbed");
}

- (void)testItShouldStubWithAsAPartialMock {
    id mockedObject = [[Cruiser alloc] initWithCallsign:@"asdf"];
    id mock = [KWMock partialMockForObject:mockedObject];
    [mock stub:@selector(callsign) andReturn:@"test callsign"];
    STAssertEqualObjects([mock callsign], @"test callsign", @"expected the partial mock to hit a stub when defined");
}

- (void)testItShouldNotRaiseForWhitelistedMethods {
    id mock = [Cruiser mock];
    STAssertNoThrow([mock isEqual:mock], @"expected no exception");
    STAssertNoThrow([mock hash], @"expected no exception");
    STAssertNoThrow([mock description], @"expected no exception");
}

- (void)testItShouldNotifyMultipleSpiesWithDifferentMessagePatterns {
    Cruiser *mock = [Cruiser mock];
    TestSpy *spy1 = [TestSpy testSpy];
    TestSpy *spy2 = [TestSpy testSpy];
    KWMessagePattern *messagePattern1 = [KWMessagePattern messagePatternWithSelector:@selector(energyLevelInWarpCore:)];
    NSArray *argumentFilters = @[[KWValue valueWithUnsignedInt:2]];
    KWMessagePattern *messagePattern2 = [KWMessagePattern messagePatternWithSelector:@selector(energyLevelInWarpCore:) argumentFilters:argumentFilters];

    [mock addMessageSpy:spy1 forMessagePattern:messagePattern1];
    [mock addMessageSpy:spy2 forMessagePattern:messagePattern2];
    [mock energyLevelInWarpCore:2];

    STAssertTrue(spy1.wasNotified, @"expected object to notify spies");
    STAssertTrue(spy2.wasNotified, @"expected object to notify spies");
}

- (void)testItShouldBeAKindOfMockedClass {
    id mock = [Cruiser mock];
    STAssertTrue([mock isKindOfClass:[Cruiser class]], @"expected mock to be a kind of mocked class");
}

- (void)testItShouldBeAKindOfMockedClassAncestor {
    id mock = [Cruiser mock];
    STAssertTrue([mock isKindOfClass:[SpaceShip class]], @"expected mock to be a kind of mocked class");
}

- (void)testItShouldBeAMemberOfMockedClass {
    id mock = [Cruiser mock];
    STAssertTrue([mock isMemberOfClass:[Cruiser class]], @"expected mock to be a member of mocked class");
}

- (void)testItShouldRespondToSelectorsInMockedClasses {
    id mock = [Cruiser mock];
    STAssertTrue([mock respondsToSelector:@selector(raiseShields)], @"expected mock to respond to selector");
    STAssertTrue([mock respondsToSelector:@selector(energyLevelInWarpCore:)], @"expected mock to respond to selector");
    STAssertFalse([mock respondsToSelector:@selector(objectAtIndex:)], @"expected mock not to respond to selector");
}

- (void)testItShouldConformToProtocolsThatMockedClassConformsTo {
    id mock = [Cruiser mock];
    STAssertTrue([mock conformsToProtocol:@protocol(JumpCapable)], @"expected mock to conform to protocol");
}

- (void)testItShouldReturnMethodSignaturesForMethodsOfMockedClasses {
    id mock = [Cruiser mock];
    NSMethodSignature *signature = [mock methodSignatureForSelector:@selector(computeStarHashForKey:)];
    STAssertTrue(KWObjCTypeEqualToObjCType([signature methodReturnType], @encode(NSUInteger)), @"expected return types to match");
    STAssertEquals([signature numberOfMessageArguments], 1u, @"expected number of arguments to match");
    STAssertTrue(KWObjCTypeEqualToObjCType([signature messageArgumentTypeAtIndex:0], @encode(NSUInteger)), @"expected argument types to match");
}

- (void)testItShouldReturnResultsForMethodsOfMockedClass {
    id mock = [Cruiser mock];
    [mock stub:@selector(energyLevelInWarpCore:)];
    STAssertEquals([mock energyLevelInWarpCore:4], 0.0f, @"expected method to be stubbed");
}

- (void)testItShouldStubAndReturnResultsForMethodsOfMockedClass {
    id mock = [Cruiser mock];
    [mock stub:@selector(energyLevelInWarpCore:) andReturn:[KWValue valueWithFloat:123.456f]];
    STAssertEquals([mock energyLevelInWarpCore:41111], 123.456f, @"expected method to be stubbed");
}

- (void)testItShouldConformToMockedProtocols {
    id mock = [KWMock mockForProtocol:@protocol(JumpCapable)];
    STAssertTrue([mock conformsToProtocol:@protocol(JumpCapable)], @"expected mock to conform to protocol");
}

- (void)testItShouldRespondToSelectorsInMockedProtocols {
    id mock = [KWMock mockForProtocol:@protocol(JumpCapable)];
    STAssertTrue([mock respondsToSelector:@selector(computeParsecs)], @"expected mock to respond to selector");
    STAssertTrue([mock respondsToSelector:@selector(engageHyperdrive)], @"expected mock to respond to selector");
    STAssertTrue([mock respondsToSelector:@selector(hyperdriveFuelLevel)], @"expected mock to respond to selector");
    STAssertFalse([mock respondsToSelector:@selector(exampleWillEnd)], @"expected mock not to respond to selector");
}

- (void)testItShouldConformToIndirectConformedProtocols {
    id mock = [KWMock mockForProtocol:@protocol(JumpCapable)];
    STAssertTrue([mock conformsToProtocol:@protocol(OrbitCapable)], @"expected mock to conform to protocol");
}

- (void)testItShouldReturnMethodSignaturesForMethodsOfMockedProtocols {
    id mock = [KWMock mockForProtocol:@protocol(JumpCapable)];
    NSMethodSignature *signature = [mock methodSignatureForSelector:@selector(hyperdriveFuelLevel)];
    STAssertTrue(KWObjCTypeEqualToObjCType([signature methodReturnType], @encode(NSUInteger)), @"expected return types to match");
    STAssertEquals([signature numberOfMessageArguments], 0u, @"expected number of arguments to match");
}

- (void)testItShouldReturnResultsForMethodsOfMockedProtocols {
    id mock = [KWMock mockForProtocol:@protocol(JumpCapable)];
    [mock stub:@selector(hyperdriveFuelLevel)];
    STAssertEquals([mock hyperdriveFuelLevel], 0u, @"expected method to be stubbed");
}

- (void)testItShouldReturnMethodSignaturesForMethodsOfIndirectConformedProtocols {
    id mock = [KWMock mockForProtocol:@protocol(JumpCapable)];
    NSMethodSignature *signature = [mock methodSignatureForSelector:@selector(orbitPeriodForMass:)];
    STAssertTrue(KWObjCTypeEqualToObjCType([signature methodReturnType], @encode(float)), @"expected return types to match");
    STAssertEquals([signature numberOfMessageArguments], 1u, @"expected number of arguments to match");
    STAssertTrue(KWObjCTypeEqualToObjCType([signature messageArgumentTypeAtIndex:0], @encode(float)), @"expected argument types to match");
}

- (void)testItShouldStubAndReturnResultsForMethodsOfMockedProtocols {
    id mock = [KWMock mockForProtocol:@protocol(JumpCapable)];
    [mock stub:@selector(hyperdriveFuelLevel) andReturn:[KWValue valueWithUnsignedInt:4242]];
    STAssertEquals([mock hyperdriveFuelLevel], 4242u, @"expected method to be stubbed");
}

- (void)testItShouldReturnResultsForMethodsOfIndirectConformedProtocols {
    id mock = [KWMock mockForProtocol:@protocol(JumpCapable)];
    [mock stub:@selector(orbitPeriodForMass:)];
    STAssertEquals([mock orbitPeriodForMass:20.0f], 0.0f, @"expected method to be stubbed");
}

- (void)testItShouldStubAndReturnResultsForMethodsOfIndirectConformedProtocols {
    id mock = [KWMock mockForProtocol:@protocol(JumpCapable)];
    [mock stub:@selector(orbitPeriodForMass:) andReturn:[KWValue valueWithFloat:100.0f]];
    STAssertEquals([mock orbitPeriodForMass:20.0f], 100.0f, @"expected method to be stubbed");
}

- (void)testItShouldStubAndUnstubStubCopy {
    id mock = [Cruiser mock];
    [mock stub:@selector(copy) andReturn:mock];
    id cruiser = [mock copy];
    STAssertEquals(mock, cruiser, @"expected copy to be stubbed");
    [mock clearStubs];
    //STAssertThrows([mock copy], @"expected copy to be unstubbed"); // NSInvocation bug
}

- (void)testItShouldStubAndUnstubStubMutableCopy {
    id mock = [Cruiser mock];
    [mock stub:@selector(mutableCopy) andReturn:mock];
    id cruiser = [mock mutableCopy];
    STAssertEquals(mock, cruiser, @"expected copy to be stubbed");
    [mock clearStubs];
    //STAssertThrows([mock mutableCopy], @"expected copy to be unstubbed"); // NSInvocation bug
}

- (void)testItShouldStubInit {
    id mock = [Cruiser nullMock];
    id otherMock = [Cruiser mock];
    [Cruiser stub:@selector(alloc) andReturn:mock];
    [mock stub:@selector(init) andReturn:otherMock];
    id cruiser = [[Cruiser alloc] init];
    STAssertEquals(cruiser, otherMock, @"expected init to be stubbed");
}

- (void)testItShouldStubInitAndReturnSelfByDefaultForNullMocks {
    id mock = [Cruiser nullMock];
    [Cruiser stub:@selector(alloc) andReturn:mock];
    id cruiser = [[Cruiser alloc] init];
    STAssertEquals(cruiser, mock, @"expected init to be stubbed");
}

- (void)testItShouldNotRaiseWhenReceivingKVCMessagesAsANullMock {
    id mock = [Cruiser nullMock];
    STAssertNoThrow([mock valueForKey:@"foo"], @"expected valueForKey: not to raise");
    STAssertNoThrow([mock setValue:@"bar" forKey:@"foo"], @"expected setValue:forKey not to raise");
    STAssertNoThrow([mock valueForKeyPath:@"foo.bar"], @"expected valueForKeyPath: not to raise");
    STAssertNoThrow([mock setValue:@"baz" forKeyPath:@"foo.bar"], @"expected setValue:forKeyPath: not to raise");
}

- (void)testItShouldAllowStubbingValueForKey {
    id mock = [Cruiser mock];
    id otherMock = [Cruiser mock];
    [mock stub:@selector(valueForKey:) andReturn:otherMock withArguments:@"foo"];
    id value = [mock valueForKey:@"foo"];
    STAssertEquals(value, otherMock, @"expected valueForKey: to be stubbed");
}

- (void)testItShouldAllowStubbingValueForKeyPath {
    id mock = [Cruiser mock];
    id otherMock = [Cruiser mock];
    [mock stub:@selector(valueForKeyPath:) andReturn:otherMock withArguments:@"foo.bar"];
    id value = [mock valueForKeyPath:@"foo.bar"];
    STAssertEquals(value, otherMock, @"expected valueForKeyPath: to be stubbed");
}

- (void)testItShouldAllowStubbingSetValueForKey {
    id mock = [Cruiser mock];
    __block BOOL called = NO;
    [mock stub:@selector(setValue:forKey:) withBlock:^id(NSArray *params) {
        STAssertEquals(params[0], @"baz", @"expected arg 1 of setValue:forKey: to be 'baz'");
        STAssertEquals(params[1], @"foo", @"expected arg 2 of setValue:forKey: to be 'foo'");
        called = YES;
        return nil;
    }];
    [mock setValue:@"baz" forKey:@"foo"];
    STAssertTrue(called, @"expected setValue:forKey: to be stubbed");
}

- (void)testItShouldAllowStubbingSetValueForKeyPath {
    id mock = [Cruiser mock];
    __block BOOL called = NO;
    [mock stub:@selector(setValue:forKeyPath:) withBlock:^id(NSArray *params) {
        STAssertEquals(params[0], @"baz", @"expected arg 1 of setValue:forKeyPath: to be 'baz'");
        STAssertEquals(params[1], @"foo.bar", @"expected arg 2 of setValue:forKey: to be 'foo.bar'");
        called = YES;
        return nil;
    }];
    [mock setValue:@"baz" forKeyPath:@"foo.bar"];
    STAssertTrue(called, @"expected setValue:forKeyPath: to be stubbed");
}

@end

#endif // #if KW_TESTS_ENABLED
