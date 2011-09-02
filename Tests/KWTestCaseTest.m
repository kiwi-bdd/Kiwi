//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

#if KW_TESTS_ENABLED

@interface KWTestCaseTest : SenTestCase

@end

@implementation KWTestCaseTest

- (void)testItShouldClearStubsAfterExamplesRun {
    KWTestCase *testCase = [[[KWTestCase alloc] init] autorelease];
    id subject = [Cruiser cruiser];
    NSUInteger crewComplement = [subject crewComplement];
    [subject stub:@selector(crewComplement) andReturn:[KWValue valueWithUnsignedInt:42]];
    STAssertEquals([subject crewComplement], 42u, @"expected method to be stubbed");

    [testCase tearDownExampleEnvironment];

    STAssertEquals([subject crewComplement], crewComplement, @"expected method stub to be cleared after examples run");
}

- (void)testItShouldNotifyVerifiersOfEndOfExample {
    KWTestCase *testCase = [[[KWTestCase alloc] init] autorelease];
    id verifier = [[[TestVerifier alloc] init] autorelease];

    [testCase addVerifier:verifier];
    [testCase invokeTest];
    STAssertTrue([verifier notifiedOfEndOfExample], @"expected spec to notify end of example verifiers");
}

@end

#endif // #if KW_TESTS_ENABLED
