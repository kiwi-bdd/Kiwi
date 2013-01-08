//
// Licensed under the terms in License.txt
//
// Copyright 2012 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "KWIntercept.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWMockForTest : SenTestCase

@end

@implementation KWMockForTest

- (void)tearDown {
	KWClearStubsAndSpies();
}

- (void)testItCanNullMockADependencyWithASpecifiedType {
	Cruiser *cruiser = [[[Cruiser alloc] init] autorelease];
	id engine = [cruiser nullMockFor:@"engine" ofType:[Engine class]];
	STAssertNotNil(engine, @"expected nullMockFor:ofType: to return a value");
	STAssertTrue([engine isNullMock], @"expected nullMockFor:ofType: to return a null mock");
	STAssertTrue([engine isKindOfClass:[Engine class]], @"expected mock to be of the correct type");
	STAssertTrue(engine == [cruiser valueForKey:@"engine"], @"expected mock to be injected");
}

- (void)testItCanMockADependencyWithASpecifiedType {
	Cruiser *cruiser = [[[Cruiser alloc] init] autorelease];
	id engine = [cruiser mockFor:@"engine" ofType:[Engine class]];
	STAssertNotNil(engine, @"expected mockFor:ofType: to return a value");
	STAssertFalse([engine isNullMock], @"expected mockFor:ofType: to return a mock which isn't a null mock");
	STAssertTrue([engine isKindOfClass:[Engine class]], @"expected mock to be of the correct type");
	STAssertTrue(engine == [cruiser valueForKey:@"engine"], @"expected mock to be injected");
}

- (void)testItCanNullMockADependencyWithASpecifiedProtocol {
	Cruiser *cruiser = [[[Cruiser alloc] init] autorelease];
	id engine = [cruiser nullMockFor:@"engine" conformingToProtocol:@protocol(JumpCapable)];
	STAssertNotNil(engine, @"expected mockFor:conformingToProtcol: to return a value");
	STAssertTrue([engine isNullMock], @"expected mockFor:conformingToProtocol: to return a null mock");
	STAssertTrue([engine conformsToProtocol:@protocol(JumpCapable)], @"expected result to conform to <JumpCapable>");
	STAssertTrue(engine == [cruiser valueForKey:@"engine"], @"expected mock to be injected");
}

- (void)testItCanMockADependencyWithASpecifiedProtocol {
	Cruiser *cruiser = [[[Cruiser alloc] init] autorelease];
	id engine = [cruiser mockFor:@"engine" conformingToProtocol:@protocol(JumpCapable)];
	STAssertNotNil(engine, @"expected mockFor:conformingToProtcol: to return a value");
	STAssertFalse([engine isNullMock], @"expected mockFor:conformingToProtocol: to return a null mock");
	STAssertTrue([engine conformsToProtocol:@protocol(JumpCapable)], @"expected result to conform to <JumpCapable>");
	STAssertTrue(engine == [cruiser valueForKey:@"engine"], @"expected mock to be injected");
}

- (void)testItShouldReturnTheSameNullMockEachTime {
	Cruiser *cruiser = [[[Cruiser alloc] init] autorelease];
	id engine1 = [cruiser nullMockFor:@"engine" ofType:[Engine class]];
	id engine2 = [cruiser nullMockFor:@"engine" ofType:[Engine class]];
	STAssertTrue(engine1 == engine2, @"expectd nullMockFor:ofType: to return the same mock each time");
}

- (void)testItShouldReturnTheSameMockEachTime {
	Cruiser *cruiser = [[[Cruiser alloc] init] autorelease];
	id engine1 = [cruiser mockFor:@"engine" ofType:[Engine class]];
	id engine2 = [cruiser mockFor:@"engine" ofType:[Engine class]];
	STAssertTrue(engine1 == engine2, @"expectd mockFor:ofType: to return the same mock each time");
}

- (void)testItShouldReturnTheSameProtocolMockEachTime {
	Cruiser *cruiser = [[[Cruiser alloc] init] autorelease];
	id engine1 = [cruiser mockFor:@"engine" conformingToProtocol:@protocol(JumpCapable)];
	id engine2 = [cruiser mockFor:@"engine" conformingToProtocol:@protocol(JumpCapable)];
	STAssertTrue(engine1 == engine2, @"expectd mockFor:conformingToProtocol: to return the same mock each time");
}

- (void)testItShouldReturnTheSameProtocolNullMockEachTime {
	Cruiser *cruiser = [[[Cruiser alloc] init] autorelease];
	id engine1 = [cruiser nullMockFor:@"engine" conformingToProtocol:@protocol(JumpCapable)];
	id engine2 = [cruiser nullMockFor:@"engine" conformingToProtocol:@protocol(JumpCapable)];
	STAssertTrue(engine1 == engine2, @"expectd mockFor:conformingToProtocol: to return the same mock each time");
}

- (void)testItShouldDetectTypeWhenNoTypeSupplied {
	Cruiser *cruiser = [[[Cruiser alloc] init] autorelease];
    id engine = [cruiser mockFor:@"engine"];
    STAssertFalse([engine isNullMock], @"expected mockFor: to return non-null mock");
}

@end

#endif // #if KW_TESTS_ENABLED
