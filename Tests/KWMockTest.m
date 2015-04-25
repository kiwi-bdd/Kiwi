//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"
#import "KWIntercept.h"
#import "NSMethodSignature+KiwiAdditions.h"

#if KW_TESTS_ENABLED

@interface KWMockTest : XCTestCase

@end

@implementation KWMockTest

- (void)tearDown {
    KWClearStubsAndSpies();
}

- (void)testItShouldInitializeForAClassWithANameAsANullObject {
    id mockedClass = [Cruiser class];
    id name = @"Car mock";
    id mock = [KWMock nullMockWithName:name forClass:mockedClass];
    XCTAssertNotNil(mock, @"expected a mock object to be initialized");
    XCTAssertEqualObjects([mock mockedClass], mockedClass, @"expected the mockedClass property to be set");
    XCTAssertTrue([mock isNullMock], @"expected the isNullObject property to be set");
    XCTAssertEqualObjects([mock mockName], @"Car mock", @"expected class mock to have the correct mockName");
}

- (void)testItShouldInitializeForAProtocolWithANameAsANullObject {
    id mockedProtocol = @protocol(JumpCapable);
    id name = @"JumpCapable mock";
    id mock = [KWMock nullMockWithName:name forProtocol:mockedProtocol];
    XCTAssertNotNil(mock, @"expected a mock object to be initialized");
    XCTAssertEqualObjects([mock mockedProtocol], mockedProtocol, @"expected the mockedProtocol property to be set");
    XCTAssertTrue([mock isNullMock], @"expected the isNullObject property to be set");
    XCTAssertEqualObjects([mock mockName], @"JumpCapable mock", @"expected class mock to have the correct mockName");
}

- (void)testItShouldInitializeAPartialMockForAClass {
    id mockedObject = [[Cruiser alloc] init];
    id name = @"Cruiser mock";
    id mock = [KWMock partialMockWithName:name forObject:mockedObject];
    XCTAssertNotNil(mock, @"expected a mock object to be initialized");
    XCTAssertEqualObjects([mock mockedObject], mockedObject, @"expected the mockedClass property to be set");
    XCTAssertTrue([mock isPartialMock], @"expected the isPartialMock property to be set");
}

- (void)testItShouldPassThroughAMessageToTheMockedObjectAsAPartialMock {
    id callsign = @"Object Callsign";
    id mockedObject = [[Cruiser alloc] initWithCallsign:callsign];
    id mock = [KWMock partialMockForObject:mockedObject];
    id returnedCallsign = [mock callsign];
    XCTAssertEqualObjects(returnedCallsign, callsign, @"expected the partial mock to pass through a message to the object");
}

//- (void)testItShouldRaiseWhenReceivingUnexpectedMessageAsAMock {
//    id mock = [KWMock mockForClass:[Cruiser class]];
//    STAssertThrows([mock objectAtIndex:0], @"expected mock to raise exception");
//}

- (void)testItShouldNotRaiseWhenReceivingUnexpectedMessageAsANullMock {
    id mock = [Cruiser nullMock];
    XCTAssertNoThrow([mock raiseShields], @"expected null mock not to raise when receiving unexpected message");
}

- (void)testItShouldStubWithASelector {
    id mock = [Cruiser mock];
    [mock stub:@selector(raiseShields)];
    XCTAssertEqual([mock raiseShields], NO, @"expected method to be stubbed with the correct value");
}

- (void)testItShouldStubTheNameMethodOnAClassMock {
    id mock = [Galaxy mock];
    [[mock stubAndReturn:@"fake galaxy mockName"] name];
    XCTAssertEqualObjects([mock name], @"fake galaxy mockName", @"expected mockName property to return the stub value");
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
    
    XCTAssertTrue(secondSpy.wasNotified, @"expected first spy to never be called");
}

- (void)testItShouldStubWithASelectorAndReturnValue {
    id mock = [Cruiser mock];
    [mock stub:@selector(crewComplement) andReturn:[KWValue valueWithUnsignedInt:42]];
    XCTAssertEqual([mock crewComplement], (NSUInteger)42, @"expected method to be stubbed with the correct value");
}

- (void)testItShouldStubWithASelectorReturnValueAndArguments {
    id mock = [Cruiser nullMock];
    [mock stub:@selector(energyLevelInWarpCore:) andReturn:theValue(30.0f) withArguments:theValue(3)];
    XCTAssertEqual([mock energyLevelInWarpCore:3], 30.0f, @"expected method with arguments to be stubbed with the correct value");
    XCTAssertTrue([mock energyLevelInWarpCore:2] != 30.0f, @"expected method with arguments not to be stubbed");
}

- (void)testItShouldStubWithASelectorReturnValueAndAnyArguments {
    id mock = [Cruiser nullMock];
    [mock stub:@selector(energyLevelInWarpCore:) andReturn:theValue(30.0f) withArguments:any()];
    XCTAssertEqual([mock energyLevelInWarpCore:3], 30.0f, @"expected method with any() arguments to be stubbed");
    XCTAssertEqual([mock energyLevelInWarpCore:2], 30.0f, @"expected method with any() arguments to be stubbed");
}

- (void)testItShouldStubWithAMessage {
    id mock = [Cruiser mock];
    XCTAssertNoThrow([[mock stub] energyLevelInWarpCore:3], @"expected mock to stub message");
    float ratio = [mock energyLevelInWarpCore:3];
    XCTAssertEqual(ratio, 0.0f, @"expected mock to have message stubbed");
}

- (void)testItShouldStubWithAReturnValueAndMessage {
    id mock = [Cruiser mock];
    XCTAssertNoThrow([[mock stubAndReturn:[KWValue valueWithFloat:42.0f]] energyLevelInWarpCore:3], @"expected mock to stub message");
    float ratio = [mock energyLevelInWarpCore:3];
    XCTAssertEqual(ratio, 42.0f, @"expected mock to have message stubbed");
}

- (void)testItShouldStubWithDifferentReturnValuesAndMessage {
    id mock = [Cruiser mock];
    XCTAssertNoThrow([[mock stubAndReturn:[KWValue valueWithFloat:42.0f] times:[KWValue valueWithInt:2] afterThatReturn:[KWValue valueWithFloat:43.0f]] energyLevelInWarpCore:3], @"expected mock to stub message");
    float firstRatio = [mock energyLevelInWarpCore:3];
    XCTAssertEqual(firstRatio, 42.0f, @"expected mock to have message stubbed");
    float secondRatio = [mock energyLevelInWarpCore:3];
    XCTAssertEqual(secondRatio, 42.0f, @"expected mock to have message stubbed");
    float thirdRatio = [mock energyLevelInWarpCore:3];
    XCTAssertEqual(thirdRatio, 43.0f, @"expected mock to have message stubbed and changed return value");
}

- (void)testItShouldClearStubbedMethods {
    id mock = [Cruiser mock];
    [mock stub:@selector(callsign) andReturn:@"Executor"];
    [mock clearStubs];
    XCTAssertNil([mock callsign], @"expected method stub to be cleared");
}

- (void)testItShouldStubWhitelistedMethods {
    id mock = [Cruiser mock];
    [mock stub:@selector(isEqual:) andReturn:[KWValue valueWithBool:YES]];
    [mock stub:@selector(hash) andReturn:[KWValue valueWithUnsignedInt:4242]];
    [mock stub:@selector(description) andReturn:@"king rat"];
    [mock stub:@selector(copy) andReturn:@"bacon"];
    XCTAssertTrue([mock isEqual:@"foobar"], @"expected method to be stubbed");
    XCTAssertEqual([mock hash], (NSUInteger)4242, @"expected method to be stubbed");
    XCTAssertEqualObjects([mock description], @"king rat", @"expected method to be stubbed");
    XCTAssertEqualObjects([mock copy], @"bacon", @"expected method to be stubbed");
}

- (void)testItShouldStubWithAsAPartialMock {
    id mockedObject = [[Cruiser alloc] initWithCallsign:@"asdf"];
    id mock = [KWMock partialMockForObject:mockedObject];
    [mock stub:@selector(callsign) andReturn:@"test callsign"];
    XCTAssertEqualObjects([mock callsign], @"test callsign", @"expected the partial mock to hit a stub when defined");
}

- (void)testItShouldNotRaiseForWhitelistedMethods {
    id mock = [Cruiser mock];
    XCTAssertNoThrow([mock isEqual:mock], @"expected no exception");
    XCTAssertNoThrow([mock hash], @"expected no exception");
    XCTAssertNoThrow([mock description], @"expected no exception");
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

    XCTAssertTrue(spy1.wasNotified, @"expected object to notify spies");
    XCTAssertTrue(spy2.wasNotified, @"expected object to notify spies");
}

- (void)testItShouldBeAKindOfMockedClass {
    id mock = [Cruiser mock];
    XCTAssertTrue([mock isKindOfClass:[Cruiser class]], @"expected mock to be a kind of mocked class");
}

- (void)testItShouldBeAKindOfMockedClassAncestor {
    id mock = [Cruiser mock];
    XCTAssertTrue([mock isKindOfClass:[SpaceShip class]], @"expected mock to be a kind of mocked class");
}

- (void)testItShouldBeAMemberOfMockedClass {
    id mock = [Cruiser mock];
    XCTAssertTrue([mock isMemberOfClass:[Cruiser class]], @"expected mock to be a member of mocked class");
}

- (void)testItShouldRespondToSelectorsInMockedClasses {
    id mock = [Cruiser mock];
    XCTAssertTrue([mock respondsToSelector:@selector(raiseShields)], @"expected mock to respond to selector");
    XCTAssertTrue([mock respondsToSelector:@selector(energyLevelInWarpCore:)], @"expected mock to respond to selector");
    XCTAssertFalse([mock respondsToSelector:@selector(objectAtIndex:)], @"expected mock not to respond to selector");
}

- (void)testItShouldConformToProtocolsThatMockedClassConformsTo {
    id mock = [Cruiser mock];
    XCTAssertTrue([mock conformsToProtocol:@protocol(JumpCapable)], @"expected mock to conform to protocol");
}

- (void)testItShouldReturnMethodSignaturesForMethodsOfMockedClasses {
    id mock = [Cruiser mock];
    NSMethodSignature *signature = [mock methodSignatureForSelector:@selector(computeStarHashForKey:)];
    XCTAssertTrue(KWObjCTypeEqualToObjCType([signature methodReturnType], @encode(NSUInteger)), @"expected return types to match");
    XCTAssertEqual([signature numberOfMessageArguments], (NSUInteger)1, @"expected number of arguments to match");
    XCTAssertTrue(KWObjCTypeEqualToObjCType([signature messageArgumentTypeAtIndex:0], @encode(NSUInteger)), @"expected argument types to match");
}

- (void)testItShouldReturnResultsForMethodsOfMockedClass {
    id mock = [Cruiser mock];
    [mock stub:@selector(energyLevelInWarpCore:)];
    XCTAssertEqual([mock energyLevelInWarpCore:4], 0.0f, @"expected method to be stubbed");
}

- (void)testItShouldStubAndReturnResultsForMethodsOfMockedClass {
    id mock = [Cruiser mock];
    [mock stub:@selector(energyLevelInWarpCore:) andReturn:[KWValue valueWithFloat:123.456f]];
    XCTAssertEqual([mock energyLevelInWarpCore:41111], 123.456f, @"expected method to be stubbed");
}

- (void)testItShouldConformToMockedProtocols {
    id mock = [KWMock mockForProtocol:@protocol(JumpCapable)];
    XCTAssertTrue([mock conformsToProtocol:@protocol(JumpCapable)], @"expected mock to conform to protocol");
}

- (void)testItShouldRespondToSelectorsInMockedProtocols {
    id mock = [KWMock mockForProtocol:@protocol(JumpCapable)];
    XCTAssertTrue([mock respondsToSelector:@selector(computeParsecs)], @"expected mock to respond to selector");
    XCTAssertTrue([mock respondsToSelector:@selector(engageHyperdrive)], @"expected mock to respond to selector");
    XCTAssertTrue([mock respondsToSelector:@selector(hyperdriveFuelLevel)], @"expected mock to respond to selector");
    XCTAssertFalse([mock respondsToSelector:@selector(exampleWillEnd)], @"expected mock not to respond to selector");
}

- (void)testItShouldConformToIndirectConformedProtocols {
    id mock = [KWMock mockForProtocol:@protocol(JumpCapable)];
    XCTAssertTrue([mock conformsToProtocol:@protocol(OrbitCapable)], @"expected mock to conform to protocol");
}

- (void)testItShouldReturnMethodSignaturesForMethodsOfMockedProtocols {
    id mock = [KWMock mockForProtocol:@protocol(JumpCapable)];
    NSMethodSignature *signature = [mock methodSignatureForSelector:@selector(hyperdriveFuelLevel)];
    XCTAssertTrue(KWObjCTypeEqualToObjCType([signature methodReturnType], @encode(NSUInteger)), @"expected return types to match");
    XCTAssertEqual([signature numberOfMessageArguments], (NSUInteger)0, @"expected number of arguments to match");
}

- (void)testItShouldReturnResultsForMethodsOfMockedProtocols {
    id mock = [KWMock mockForProtocol:@protocol(JumpCapable)];
    [mock stub:@selector(hyperdriveFuelLevel)];
    XCTAssertEqual([mock hyperdriveFuelLevel], (NSUInteger)0, @"expected method to be stubbed");
}

- (void)testItShouldReturnMethodSignaturesForMethodsOfIndirectConformedProtocols {
    id mock = [KWMock mockForProtocol:@protocol(JumpCapable)];
    NSMethodSignature *signature = [mock methodSignatureForSelector:@selector(orbitPeriodForMass:)];
    XCTAssertTrue(KWObjCTypeEqualToObjCType([signature methodReturnType], @encode(float)), @"expected return types to match");
    XCTAssertEqual([signature numberOfMessageArguments], (NSUInteger)1, @"expected number of arguments to match");
    XCTAssertTrue(KWObjCTypeEqualToObjCType([signature messageArgumentTypeAtIndex:0], @encode(float)), @"expected argument types to match");
}

- (void)testItShouldStubAndReturnResultsForMethodsOfMockedProtocols {
    id mock = [KWMock mockForProtocol:@protocol(JumpCapable)];
    [mock stub:@selector(hyperdriveFuelLevel) andReturn:[KWValue valueWithUnsignedInt:4242]];
    XCTAssertEqual([mock hyperdriveFuelLevel], (NSUInteger)4242, @"expected method to be stubbed");
}

- (void)testItShouldReturnResultsForMethodsOfIndirectConformedProtocols {
    id mock = [KWMock mockForProtocol:@protocol(JumpCapable)];
    [mock stub:@selector(orbitPeriodForMass:)];
    XCTAssertEqual([mock orbitPeriodForMass:20.0f], 0.0f, @"expected method to be stubbed");
}

- (void)testItShouldStubAndReturnResultsForMethodsOfIndirectConformedProtocols {
    id mock = [KWMock mockForProtocol:@protocol(JumpCapable)];
    [mock stub:@selector(orbitPeriodForMass:) andReturn:[KWValue valueWithFloat:100.0f]];
    XCTAssertEqual([mock orbitPeriodForMass:20.0f], 100.0f, @"expected method to be stubbed");
}

- (void)testItShouldStubAndUnstubStubCopy {
    id mock = [Cruiser mock];
    [mock stub:@selector(copy) andReturn:mock];
    id cruiser = [mock copy];
    XCTAssertEqual(mock, cruiser, @"expected copy to be stubbed");
    [mock clearStubs];
    //STAssertThrows([mock copy], @"expected copy to be unstubbed"); // NSInvocation bug
}

- (void)testItShouldStubAndUnstubStubMutableCopy {
    id mock = [Cruiser mock];
    [mock stub:@selector(mutableCopy) andReturn:mock];
    id cruiser = [mock mutableCopy];
    XCTAssertEqual(mock, cruiser, @"expected copy to be stubbed");
    [mock clearStubs];
    //STAssertThrows([mock mutableCopy], @"expected copy to be unstubbed"); // NSInvocation bug
}

- (void)testItShouldStubInit {
    id mock = [Cruiser nullMock];
    id otherMock = [Cruiser mock];
    [Cruiser stub:@selector(alloc) andReturn:mock];
    [mock stub:@selector(init) andReturn:otherMock];
    id cruiser = [[Cruiser alloc] init];
    XCTAssertEqual(cruiser, otherMock, @"expected init to be stubbed");
}

- (void)testItShouldStubInitAndReturnSelfByDefaultForNullMocks {
    id mock = [Cruiser nullMock];
    [Cruiser stub:@selector(alloc) andReturn:mock];
    id cruiser = [[Cruiser alloc] init];
    XCTAssertEqual(cruiser, mock, @"expected init to be stubbed");
}

- (void)testItShouldNotRaiseWhenReceivingKVCMessagesAsANullMock {
    id mock = [Cruiser nullMock];
    XCTAssertNoThrow([mock valueForKey:@"foo"], @"expected valueForKey: not to raise");
    XCTAssertNoThrow([mock setValue:@"bar" forKey:@"foo"], @"expected setValue:forKey not to raise");
    XCTAssertNoThrow([mock valueForKeyPath:@"foo.bar"], @"expected valueForKeyPath: not to raise");
    XCTAssertNoThrow([mock setValue:@"baz" forKeyPath:@"foo.bar"], @"expected setValue:forKeyPath: not to raise");
}

- (void)testItShouldAllowStubbingValueForKey {
    id mock = [Cruiser mock];
    id otherMock = [Cruiser mock];
    [mock stub:@selector(valueForKey:) andReturn:otherMock withArguments:@"foo"];
    id value = [mock valueForKey:@"foo"];
    XCTAssertEqual(value, otherMock, @"expected valueForKey: to be stubbed");
}

- (void)testItShouldAllowStubbingValueForKeyPath {
    id mock = [Cruiser mock];
    id otherMock = [Cruiser mock];
    [mock stub:@selector(valueForKeyPath:) andReturn:otherMock withArguments:@"foo.bar"];
    id value = [mock valueForKeyPath:@"foo.bar"];
    XCTAssertEqual(value, otherMock, @"expected valueForKeyPath: to be stubbed");
}

- (void)testItShouldAllowStubbingSetValueForKey {
    id mock = [Cruiser mock];
    __block BOOL called = NO;
    [mock stub:@selector(setValue:forKey:) withBlock:^id(NSArray *params) {
        XCTAssertEqual(params[0], @"baz", @"expected arg 1 of setValue:forKey: to be 'baz'");
        XCTAssertEqual(params[1], @"foo", @"expected arg 2 of setValue:forKey: to be 'foo'");
        called = YES;
        return nil;
    }];
    [mock setValue:@"baz" forKey:@"foo"];
    XCTAssertTrue(called, @"expected setValue:forKey: to be stubbed");
}

- (void)testItShouldAllowStubbingSetValueForKeyPath {
    id mock = [Cruiser mock];
    __block BOOL called = NO;
    [mock stub:@selector(setValue:forKeyPath:) withBlock:^id(NSArray *params) {
        XCTAssertEqual(params[0], @"baz", @"expected arg 1 of setValue:forKeyPath: to be 'baz'");
        XCTAssertEqual(params[1], @"foo.bar", @"expected arg 2 of setValue:forKey: to be 'foo.bar'");
        called = YES;
        return nil;
    }];
    [mock setValue:@"baz" forKeyPath:@"foo.bar"];
    XCTAssertTrue(called, @"expected setValue:forKeyPath: to be stubbed");
}

@end

#endif // #if KW_TESTS_ENABLED
