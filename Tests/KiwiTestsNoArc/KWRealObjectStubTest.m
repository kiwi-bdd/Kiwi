//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"
#import "KWIntercept.h"

#if KW_TESTS_ENABLED

@interface KWRealObjectStubTest : XCTestCase

@end

@implementation KWRealObjectStubTest

- (void)tearDown {
    KWClearStubsAndSpies();
}

- (void)testItShouldRaiseWhenStubbingNonExistentMethods {
    Cruiser *cruiser = [Cruiser cruiserWithCallsign:@"Galactica"];
    XCTAssertThrows([cruiser stub:@selector(objectAtIndex:)], @"expected exception");
}

- (void)testItShouldNullStubInstanceMethodsReturningObjects {
    Cruiser *cruiser = [Cruiser cruiserWithCallsign:@"Galactica"];
    [cruiser stub:@selector(callsign)];
    XCTAssertNil([cruiser callsign], @"expected method to be null stubbed");
}

- (void)testItShouldNullStubClassMethodsReturningObjects {
    [Cruiser stub:@selector(classification)];
    XCTAssertNil([Cruiser classification], @"expected method to be null stubbed");
    [Cruiser clearStubs];
}

- (void)testItShouldStubInstanceMethodsReturningObjects {
    Cruiser *cruiser = [Cruiser cruiserWithCallsign:@"Galactica"];
    NSString *fighterCallsign = @"Viper 1";
    Fighter *fighter = [Fighter fighterWithCallsign:fighterCallsign];
    [cruiser stub:@selector(fighterWithCallsign:) andReturn:fighter withArguments:fighterCallsign];
    XCTAssertEqual(fighter, [cruiser fighterWithCallsign:fighterCallsign], @"expected method to be stubbed");
}

- (void)testItShouldStubInstanceMethodsReturningObjectsWithAnyArguments {
    Cruiser *cruiser = [Cruiser cruiserWithCallsign:@"Galactica"];
    Fighter *fighter = [Fighter fighterWithCallsign:@"Viper 1"];
    [cruiser stub:@selector(fighterWithCallsign:) andReturn:fighter withArguments:kw_any()];
    XCTAssertEqual(fighter, [cruiser fighterWithCallsign:@"Foo"], @"expected method to be stubbed");
}

- (void)testItShouldStubInstanceMethodsThatAreUsedInTheObjectsHashMethod {
    Cruiser *cruiser = [Cruiser new];
    [cruiser stub:@selector(crewComplement) andReturn:theValue(5)];
    XCTAssertEqual((NSUInteger)5, cruiser.crewComplement, @"expected to be able to stub -[Cruiser crewComplement], which is used in -[Cruiser hash]");
}

- (void)testItShouldClearStubbedRecursiveMethods {
    NSUInteger starHash = 8 + 4 + 2 + 1;
    Cruiser *cruiser = [Cruiser cruiserWithCallsign:@"Galactica"];
    [cruiser stub:@selector(computeStarHashForKey:) andReturn:[KWValue valueWithUnsignedInteger:42]];
    [cruiser clearStubs];
    XCTAssertEqual([cruiser computeStarHashForKey:8], starHash, @"expected method to be unmodified after unstubbing");
}

- (void)testItShouldClearStubbedSuperComposedMethods {
    Cruiser *cruiser = [Cruiser cruiserWithCallsign:@"Galactica"];
    [cruiser stub:@selector(raiseShields) andReturn:[KWValue valueWithBool:NO]];
    [cruiser clearStubs];
    XCTAssertTrue([cruiser raiseShields], @"expected method to be unmodified after unstubbing");
}

- (void)testItShouldClearStubbedInstanceMethods {
    NSString *callsign = @"Galactica";
    Cruiser *cruiser = [Cruiser cruiserWithCallsign:callsign];
    [cruiser stub:@selector(callsign) andReturn:@"Executor"];
    [cruiser clearStubs];
    XCTAssertEqualObjects([cruiser callsign], callsign, @"expected method to be unmodified after unstubbing");
}

- (void)testItShouldClearStubbedClassMethods {
    NSString *expectedClassification = @"Capital Ship";
    XCTAssertEqualObjects([Cruiser classification], expectedClassification, @"expected method to be unmodified before stubbing");
    [Cruiser stub:@selector(classification) andReturn:@"Battle Station"];
    [Cruiser clearStubs];
    XCTAssertEqualObjects([Cruiser classification], expectedClassification, @"expected method to be unmodified after unstubbing");
}

- (void)testItShouldStubTheNextMessage {
    NSString *callsign = @"Galactica";
    Cruiser *cruiser = [Cruiser cruiserWithCallsign:@"Avenger"];
    [cruiser stub:@selector(callsign) andReturn:callsign];
    XCTAssertEqualObjects([cruiser callsign], callsign, @"expected method to be stubbed");
}

- (void)testItShouldStubTheNextMessagesAndReturnDifferentValues {
    NSString *callsign = @"Galactica";
    NSString *secondCallsign = @"Andromeda";
    Cruiser *cruiser = [Cruiser cruiserWithCallsign:@"Avenger"];
    [cruiser stub:@selector(callsign) andReturn:callsign times:@2 afterThatReturn:secondCallsign];
    XCTAssertEqualObjects([cruiser callsign], callsign, @"expected method to be stubbed");
    XCTAssertEqualObjects([cruiser callsign], callsign, @"expected method to be stubbed");
    XCTAssertEqualObjects([cruiser callsign], secondCallsign, @"expected method to be stubbed and change return value");
}

- (void)testItShouldSubstituteMethodImplementationWithBlock {
    __block BOOL shieldsRaised = NO;
    Cruiser *cruiser = [Cruiser new];
    [cruiser stub:@selector(raiseShields) withBlock:(id) ^(NSArray *params) {
        shieldsRaised = YES;
        return NO;
    }];
    [cruiser raiseShields];
    XCTAssertEqual(shieldsRaised, YES, @"expected method implementation to be substituted");
}

- (void)testItShouldPreserveClassResultWhenInstanceMethodStubbed {
    id subject = [Cruiser new];
    Class originalClass = [subject class];
    [subject stub:@selector(raiseShields) andReturn:[KWValue valueWithBool:YES]];
    XCTAssertEqual([subject class], originalClass, @"expected class to be preserved");
}

- (void)testItShouldPreserveSuperclassResultWhenInstanceMethodStubbed {
    id subject = [Cruiser new];
    Class originalSuperclass = [subject superclass];
    [subject stub:@selector(raiseShields) andReturn:[KWValue valueWithBool:YES]];
    XCTAssertEqual([subject superclass], originalSuperclass, @"expected superclass to be preserved");
}

- (void)testItShouldPreserveClassResultWhenClassMethodStubbed {
    Class originalClass = [Cruiser class];
    [Cruiser stub:@selector(classification) andReturn:@"animal"];
    XCTAssertEqual([Cruiser class], originalClass, @"expected class to be preserved");
}

- (void)testItShouldPreserveSuperclassResultWhenClassMethodStubbed {
    Class originalSuperclass = [Cruiser superclass];
    [Cruiser stub:@selector(classification) andReturn:@"animal"];
    XCTAssertEqual([Cruiser superclass], originalSuperclass, @"expected superclass to be preserved");
}

- (void)testItShouldStubAndUnstubAlloc {
    id mock = [Cruiser mock];
    [mock stub:@selector(initWithCallsign:) andReturn:mock];
    [Cruiser stub:@selector(alloc) andReturn:mock];
    id cruiser = [[Cruiser alloc] initWithCallsign:@"Imperium"];
    XCTAssertEqual(mock, cruiser, @"expected alloc to be stubbed");
    [Cruiser clearStubs];
    cruiser = [[Cruiser alloc] initWithCallsign:@"Imperium"];
    XCTAssertTrue(mock != cruiser, @"expected alloc to be unstubbed");
}

- (void)testItShouldStubAndUnstubNew {
    id mock = [Cruiser mock];
    [mock stub:@selector(initWithCallsign:) andReturn:mock];
    [Cruiser stub:@selector(new) andReturn:mock];
    id cruiser = [Cruiser new];
    XCTAssertEqual(mock, cruiser, @"expected alloc to be stubbed");
    [Cruiser clearStubs];
    cruiser = [Cruiser new];
    XCTAssertTrue(mock != cruiser, @"expected alloc to be unstubbed");
}

- (void)testItShouldStubInit {
    id subject = [Cruiser new];
    id otherCruiser = [Cruiser new];
    [Cruiser stub:@selector(alloc) andReturn:subject];
    [subject stub:@selector(init) andReturn:otherCruiser];
    id cruiser = [[Cruiser alloc] init];
    XCTAssertEqual(cruiser, otherCruiser, @"expected init to be stubbed");
}

- (void)testSpyWorksOnRealInterfaces {
    Fighter *cruiser = [Fighter mock];
    SEL cruiserSEL = NSSelectorFromString(@"cruiser");
    XCTAssertNoThrow([cruiser captureArgument:cruiserSEL atIndex:0], @"expected not to throw exception");
}

- (void)testCallingCaptureArgumentOnRealObjectThrowsException {
    Fighter *cruiser = [Fighter new];
    SEL cruiserSEL = NSSelectorFromString(@"cruiser");
    XCTAssertThrows([cruiser captureArgument:cruiserSEL atIndex:0], @"expected to throw exception");
}

- (void)testItShouldStubWithBlock {
    Cruiser *cruiser = [Cruiser new];
    [cruiser stub:@selector(classification) withBlock:^id(NSArray *params) {
        return @"Enterprise";
    }];
    XCTAssertEqual([cruiser classification], @"Enterprise", @"expected method to be stubbed with block");
}

- (void)testStubSecureCodingOfDateClass {
    NSDate *date = [NSDate date];
    [NSDate stub:@selector(date) andReturn:date];
    if (@available(macOS 10.13, iOS 11.0, watchOS 4.0, tvOS 11.0, *)) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:date requiringSecureCoding:YES error:NULL];
        XCTAssertNotNil(data, @"expected stubbed class to be able to use secure coding");
    }
}

@end

#endif // #if KW_TESTS_ENABLED
