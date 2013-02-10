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

@interface KWRealObjectStubTest : SenTestCase

@end

@implementation KWRealObjectStubTest

- (void)tearDown {
    KWClearStubsAndSpies();
}

- (void)testItShouldRaiseWhenStubbingNonExistentMethods {
    Cruiser *cruiser = [Cruiser cruiserWithCallsign:@"Galactica"];
    STAssertThrows([cruiser stub:@selector(objectAtIndex:)], @"expected exception");
}

- (void)testItShouldNullStubInstanceMethodsReturningObjects {
    Cruiser *cruiser = [Cruiser cruiserWithCallsign:@"Galactica"];
    [cruiser stub:@selector(callsign)];
    STAssertNil([cruiser callsign], @"expected method to be null stubbed");
}

- (void)testItShouldNullStubClassMethodsReturningObjects {
    [Cruiser stub:@selector(classification)];
    STAssertNil([Cruiser classification], @"expected method to be null stubbed");
    [Cruiser clearStubs];
}

- (void)testItShouldStubInstanceMethodsReturningObjects {
    Cruiser *cruiser = [Cruiser cruiserWithCallsign:@"Galactica"];
    NSString *fighterCallsign = @"Viper 1";
    Fighter *fighter = [Fighter fighterWithCallsign:fighterCallsign];
    [cruiser stub:@selector(fighterWithCallsign:) andReturn:fighter withArguments:fighterCallsign];
    STAssertEquals(fighter, [cruiser fighterWithCallsign:fighterCallsign], @"expected method to be stubbed");
}

- (void)testItShouldStubInstanceMethodsReturningObjectsWithAnyArguments {
    Cruiser *cruiser = [Cruiser cruiserWithCallsign:@"Galactica"];
    Fighter *fighter = [Fighter fighterWithCallsign:@"Viper 1"];
    [cruiser stub:@selector(fighterWithCallsign:) andReturn:fighter withArguments:any()];
    STAssertEquals(fighter, [cruiser fighterWithCallsign:@"Foo"], @"expected method to be stubbed");
}

- (void)testItShouldClearStubbedRecursiveMethods {
    NSUInteger starHash = 8 + 4 + 2 + 1;
    Cruiser *cruiser = [Cruiser cruiserWithCallsign:@"Galactica"];
    [cruiser stub:@selector(computeStarHashForKey:) andReturn:[KWValue valueWithUnsignedInteger:42]];
    [cruiser clearStubs];
    STAssertEquals([cruiser computeStarHashForKey:8], starHash, @"expected method to be unmodified after unstubbing");
}

- (void)testItShouldClearStubbedSuperComposedMethods {
    Cruiser *cruiser = [Cruiser cruiserWithCallsign:@"Galactica"];
    [cruiser stub:@selector(raiseShields) andReturn:[KWValue valueWithBool:NO]];
    [cruiser clearStubs];
    STAssertTrue([cruiser raiseShields], @"expected method to be unmodified after unstubbing");
}

- (void)testItShouldClearStubbedInstanceMethods {
    NSString *callsign = @"Galactica";
    Cruiser *cruiser = [Cruiser cruiserWithCallsign:callsign];
    [cruiser stub:@selector(callsign) andReturn:@"Executor"];
    [cruiser clearStubs];
    STAssertEqualObjects([cruiser callsign], callsign, @"expected method to be unmodified after unstubbing");
}

- (void)testItShouldClearStubbedClassMethods {
    NSString *expectedClassification = @"Capital Ship";
    STAssertEqualObjects([Cruiser classification], expectedClassification, @"expected method to be unmodified before stubbing");
    [Cruiser stub:@selector(classification) andReturn:@"Battle Station"];
    [Cruiser clearStubs];
    STAssertEqualObjects([Cruiser classification], expectedClassification, @"expected method to be unmodified after unstubbing");
}

- (void)testItShouldStubTheNextMessage {
    NSString *callsign = @"Galactica";
    Cruiser *cruiser = [Cruiser cruiserWithCallsign:@"Avenger"];
    [[cruiser stubAndReturn:callsign] callsign];
    STAssertEqualObjects([cruiser callsign], callsign, @"expected method to be stubbed");
}

- (void)testItShouldStubTheNextMessagesAndReturnDifferentValues {
    NSString *callsign = @"Galactica";
    NSString *secondCallsign = @"Andromeda";
    Cruiser *cruiser = [Cruiser cruiserWithCallsign:@"Avenger"];
    [[cruiser stubAndReturn: callsign times:[KWValue valueWithInt:2] afterThatReturn:secondCallsign] callsign];
    STAssertEqualObjects([cruiser callsign], callsign, @"expected method to be stubbed");
    STAssertEqualObjects([cruiser callsign], callsign, @"expected method to be stubbed");
    STAssertEqualObjects([cruiser callsign], secondCallsign, @"expected method to be stubbed and change return value");
}

- (void)testItShouldSubstituteMethodImplementationWithBlock {
    __block BOOL shieldsRaised = NO;
    Cruiser *cruiser = [Cruiser cruiser];
    [cruiser stub:@selector(raiseShields) withBlock:(id) ^(NSArray *params) {
        shieldsRaised = YES;
        return NO;
    }];
    [cruiser raiseShields];
    STAssertEquals(shieldsRaised, YES, @"expected method implementation to be substituted");
}

- (void)testItShouldPreserveClassResultWhenInstanceMethodStubbed {
    id subject = [Cruiser cruiser];
    Class originalClass = [subject class];
    [subject stub:@selector(raiseShields) andReturn:[KWValue valueWithBool:YES]];
    STAssertEquals([subject class], originalClass, @"expected class to be preserved");
}

- (void)testItShouldPreserveSuperclassResultWhenInstanceMethodStubbed {
    id subject = [Cruiser cruiser];
    Class originalSuperclass = [subject superclass];
    [subject stub:@selector(raiseShields) andReturn:[KWValue valueWithBool:YES]];
    STAssertEquals([subject superclass], originalSuperclass, @"expected superclass to be preserved");
}

- (void)testItShouldPreserveClassResultWhenClassMethodStubbed {
    Class originalClass = [Cruiser class];
    [Cruiser stub:@selector(classification) andReturn:@"animal"];
    STAssertEquals([Cruiser class], originalClass, @"expected class to be preserved");
}

- (void)testItShouldPreserveSuperclassResultWhenClassMethodStubbed {
    Class originalSuperclass = [Cruiser superclass];
    [Cruiser stub:@selector(classification) andReturn:@"animal"];
    STAssertEquals([Cruiser superclass], originalSuperclass, @"expected superclass to be preserved");
}

- (void)testItShouldStubAndUnstubAlloc {
    id mock = [Cruiser mock];
    [mock stub:@selector(initWithCallsign:) andReturn:mock];
    [Cruiser stub:@selector(alloc) andReturn:mock];
    id cruiser = [[Cruiser alloc] initWithCallsign:@"Imperium"];
    STAssertEquals(mock, cruiser, @"expected alloc to be stubbed");
    [Cruiser clearStubs];
    cruiser = [[Cruiser alloc] initWithCallsign:@"Imperium"];
    STAssertTrue(mock != cruiser, @"expected alloc to be unstubbed");
}

- (void)testItShouldStubAndUnstubNew {
    id mock = [Cruiser mock];
    [mock stub:@selector(initWithCallsign:) andReturn:mock];
    [Cruiser stub:@selector(new) andReturn:mock];
    id cruiser = [Cruiser new];
    STAssertEquals(mock, cruiser, @"expected alloc to be stubbed");
    [Cruiser clearStubs];
    cruiser = [Cruiser new];
    STAssertTrue(mock != cruiser, @"expected alloc to be unstubbed");
}

- (void)testItShouldStubInit {
    id subject = [Cruiser cruiser];
    id otherCruiser = [Cruiser cruiser];
    [Cruiser stub:@selector(alloc) andReturn:subject];
    [subject stub:@selector(init) andReturn:otherCruiser];
    id cruiser = [[Cruiser alloc] init];
    STAssertEquals(cruiser, otherCruiser, @"expected init to be stubbed");
}

- (void)testSpyWorksOnRealInterfaces {
    Cruiser *cruiser = [Cruiser mock];
    STAssertNoThrow([cruiser captureArgument:@selector(foo) atIndex:0], @"expected not to throw exception");
}

- (void)testCallingCaptureArgumentOnRealObjectThrowsException {
    Cruiser *cruiser = [Cruiser cruiser];
    STAssertThrows([cruiser captureArgument:@selector(foo) atIndex:0], @"expected to throw exception");
}

- (void)testItShouldStubWithBlock {
    Cruiser *cruiser = [Cruiser cruiser];
    [cruiser stub:@selector(classification) withBlock:^id(NSArray *params) {
        return @"Enterprise";
    }];
    STAssertEquals([cruiser classification], @"Enterprise", @"expected method to be stubbed with block");
}

@end

#endif // #if KW_TESTS_ENABLED
