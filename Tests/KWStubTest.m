//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"
#import "KWIntercept.h"
#import "NSInvocation+KiwiAdditions.h"

#if KW_TESTS_ENABLED

@interface KWStubTest : XCTestCase

@end

@implementation KWStubTest

- (void)tearDown {
    KWClearStubsAndSpies();
}

- (void)testItShouldProcessMatchedInvocations {
    id subject = [Cruiser cruiser];
    KWMessagePattern *messagePattern = [KWMessagePattern messagePatternWithSelector:@selector(crewComplement)];
    id stub = [KWStub stubWithMessagePattern:messagePattern value:[KWValue valueWithUnsignedInt:42]];
    id invocation = [NSInvocation invocationWithTarget:subject selector:@selector(crewComplement)];
    XCTAssertTrue([stub processInvocation:invocation], @"expected stub to process invocation");
}

- (void)testItShouldNotProcessNonMatchedInvocations {
    id subject = [Cruiser cruiser];
    id argumentFilters = @[[KWValue valueWithUnsignedInt:15]];
    KWMessagePattern *messagePattern = [KWMessagePattern messagePatternWithSelector:@selector(energyLevelInWarpCore:) argumentFilters:argumentFilters];
    id stub = [KWStub stubWithMessagePattern:messagePattern value:[KWValue valueWithFloat:13.0f]];
    NSUInteger index = 17;
    id invocation = [NSInvocation invocationWithTarget:subject selector:@selector(energyLevelInWarpCore:) messageArguments:&index];
    XCTAssertFalse([stub processInvocation:invocation], @"expected stub not to process invocation");
}

- (void)testItShouldWriteWrappedInvocationReturnValues {
    id subject = [Cruiser cruiser];
    KWMessagePattern *messagePattern = [KWMessagePattern messagePatternWithSelector:@selector(crewComplement)];
    id stub = [KWStub stubWithMessagePattern:messagePattern value:[KWValue valueWithUnsignedInt:42]];
    id invocation = [NSInvocation invocationWithTarget:subject selector:@selector(crewComplement)];
    [stub processInvocation:invocation];
    NSUInteger crewComplement = 0;
    [invocation getReturnValue:&crewComplement];
    XCTAssertEqual(crewComplement, (NSUInteger)42, @"expected stub to write return value");
}

- (void)testItShouldWriteObjectInvocationReturnValues {
    id subject = [Cruiser cruiser];
    KWMessagePattern *messagePattern = [KWMessagePattern messagePatternWithSelector:@selector(callsign)];
    id stub = [KWStub stubWithMessagePattern:messagePattern value:@"Green 1"];
    id invocation = [NSInvocation invocationWithTarget:subject selector:@selector(callsign)];
    [stub processInvocation:invocation];
    id callsign = nil;
    [invocation getReturnValue:&callsign];
    XCTAssertEqualObjects(callsign, @"Green 1", @"expected stub to write return value");
}

- (void)testItShouldPerformStubbedBlock {
    id subject = [Cruiser cruiser];
    Fighter *fighter = [[Fighter alloc] initWithCallsign:@"Red Leader"];
    KWMessagePattern *messagePattern = [KWMessagePattern messagePatternWithSelector:@selector(fighterWithCallsign:)];
    id stub  = [KWStub stubWithMessagePattern:messagePattern block: (id) ^(NSArray *params) {
        return fighter;
    }];
    NSInvocation *invocation = [NSInvocation invocationWithTarget:subject selector:@selector(fighterWithCallsign:) messageArguments:@"Random callsign"];
    [stub processInvocation:invocation];
    id outcome = nil;
    [invocation getReturnValue:&outcome];
    Fighter *result = (Fighter *)outcome;
    XCTAssertEqual(result.callsign, @"Red Leader", @"expected stub to perform given block");
}


- (void)testItShouldPerformStubbedBlockAndAppropriatelyWrapParameterOfCharacterStreamType {
    id subject = [Cruiser cruiser];
    Fighter *fighter = [[Fighter alloc] initWithCallsign:@"Red Leader"];
    KWMessagePattern *messagePattern = [KWMessagePattern messagePatternWithSelector:@selector(fighterWithCallsignUTF8CString:)];
	const char *messageArgument = "Random callsign";
    id stub  = [KWStub stubWithMessagePattern:messagePattern block: (id) ^(NSArray *params) {
		const char *passedArgumentValue = [params[0] pointerValue];
		XCTAssertTrue(strncmp(messageArgument, passedArgumentValue, strlen(messageArgument)), @"expected appropriate value in parameters to stub block");

        return fighter;
    }];
    NSInvocation *invocation = [NSInvocation invocationWithTarget:subject selector:@selector(fighterWithCallsignUTF8CString:) messageArguments:@"Random callsign"];
    [stub processInvocation:invocation];
    id outcome = nil;
    [invocation getReturnValue:&outcome];
    Fighter *result = (Fighter *)outcome;
    XCTAssertEqual(result.callsign, @"Red Leader", @"expected stub to perform given block");
}

- (void)testItShouldPerformStubbedBlockWhenInvocationHasNilArguments {
    id subject = [Cruiser cruiser];
    KWMessagePattern *messagePattern = [KWMessagePattern messagePatternWithSelector:@selector(fighterWithCallsign:)];
    id stub = [KWStub stubWithMessagePattern:messagePattern block: (id) ^(NSArray *params) {
        return [[params copy] autorelease];
    }];
    NSInvocation *invocation = [NSInvocation invocationWithTarget:subject selector:@selector(fighterWithCallsign:) messageArguments:nil];
    [stub processInvocation:invocation];
    id outcome = nil;
    [invocation getReturnValue:&outcome];
    NSArray *result = (NSArray *)outcome;
    XCTAssertEqual([result objectAtIndex:0], [NSNull null], @"expected stub convert nil arguments to NSNull");
}

- (void)testItShouldRetainValueWhenProcessingInvocationsThatBeginsWithAlloc {
    id subject = [Cruiser mock];
    id messagePattern = [KWMessagePattern messagePatternWithSelector:@selector(alloc)];
    id stub = [KWStub stubWithMessagePattern:messagePattern value:subject];
    id invocation = [NSInvocation invocationWithTarget:[Cruiser class] selector:@selector(alloc)];
    NSUInteger retainCountBefore = [subject retainCount];
    [stub processInvocation:invocation];
    NSUInteger retainCountAfter = [subject retainCount];
    XCTAssertEqual(retainCountAfter, retainCountBefore + 1, @"expected stub to retain value");
}

- (void)testItShouldRetainValueWhenProcessingInvocationsThatBeginsWithNew {
    id subject = [Cruiser mock];
    id messagePattern = [KWMessagePattern messagePatternWithSelector:@selector(new)];
    id stub = [KWStub stubWithMessagePattern:messagePattern value:subject];
    id invocation = [NSInvocation invocationWithTarget:[Cruiser class] selector:@selector(new)];
    NSUInteger retainCountBefore = [subject retainCount];
    [stub processInvocation:invocation];
    NSUInteger retainCountAfter = [subject retainCount];
    XCTAssertEqual(retainCountAfter, retainCountBefore + 1, @"expected stub to retain value");
}

- (void)testItShouldRetainValueWhenProcessingInvocationsThatContainsCopy {
    id subject = [Cruiser mock];
    id messagePattern = [KWMessagePattern messagePatternWithSelector:@selector(copy)];
    id stub = [KWStub stubWithMessagePattern:messagePattern value:subject];
    id invocation = [NSInvocation invocationWithTarget:[Cruiser class] selector:@selector(copy)];
    NSUInteger retainCountBefore = [subject retainCount];
    [stub processInvocation:invocation];
    NSUInteger retainCountAfter = [subject retainCount];
    XCTAssertEqual(retainCountAfter, retainCountBefore + 1, @"expected stub to retain value");

    subject = [Cruiser mock];
    messagePattern = [KWMessagePattern messagePatternWithSelector:@selector(mutableCopy)];
    stub = [KWStub stubWithMessagePattern:messagePattern value:subject];
    invocation = [NSInvocation invocationWithTarget:[Cruiser class] selector:@selector(mutableCopy)];
    retainCountBefore = [subject retainCount];
    [stub processInvocation:invocation];
    retainCountAfter = [subject retainCount];
    XCTAssertEqual(retainCountAfter, retainCountBefore + 1, @"expected stub to retain value");
}

- (void)testItShouldUseIdAsDefaultReturnType{
    id mock = [Cruiser mock];
    SEL selector = NSSelectorFromString(@"unknownMethod");
    [mock stub:selector];
    XCTAssertEqualObjects(@([mock methodSignatureForSelector:selector].methodReturnType), @"@", @"expected id as default return type");
}

@end

#endif // #if KW_TESTS_ENABLED
