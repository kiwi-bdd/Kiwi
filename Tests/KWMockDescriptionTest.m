//
// Licensed under the terms in License.txt
//
// Copyright 2012 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"
#import "KWIntercept.h"

#if KW_TESTS_ENABLED

@interface KWMockDescriptionTest : SenTestCase

@end

@implementation KWMockDescriptionTest

- (void)tearDown {
    KWClearStubsAndSpies();
}

- (void)testItShouldProduceAValidClassMockFromAClassTypeSignature {
    STAssertEqualObjects(
            [KWMockDescription null:NO mockForTypeEncoding:"@\"Cruiser\""],
            [KWMockDescription null:NO mockForClass:[Cruiser class]],
            @"expected parsing '@\"Cruiser\"' to return a description which would mock Cruiser"
            );
}

- (void)testItShouldProduceAnNSObjectMockForAnIdSignature {
    STAssertEqualObjects(
           [KWMockDescription null:NO mockForTypeEncoding:"@"],
           [KWMockDescription null:NO mockForClass:[NSObject class]],
           @"expected parsing '@' to return a description which would mock NSObject"
           );
}

- (void)testItShouldProduceAProtocolMockForAProtooclTypeSignature {
    STAssertEqualObjects(
           [KWMockDescription null:NO mockForTypeEncoding:"@\"<NSStreamDelegate>\""],
           [KWMockDescription null:NO mockForProtocol:@protocol(NSStreamDelegate)],
           @"expected parsing '@\"<NSStreamDelegate>\"' to return a description which would mock the protocol"
           );
}

- (void)testItShouldRaiseAUsefulErrorIfItCannotMockTheType {
    STAssertThrows(
            [KWMockDescription null:NO mockForTypeEncoding:"i"],
            @"expected parsing 'i' to throw a useful error."
            );
}

- (void)testItShouldProduceAValidClassNullMockFromAClassTypeSignature {
    STAssertEqualObjects(
            [KWMockDescription null:YES mockForTypeEncoding:"@\"Cruiser\""],
            [KWMockDescription null:YES mockForClass:[Cruiser class]],
            @"expected parsing '@\"Cruiser\"' to return a description which would mock Cruiser"
            );
}


@end

#endif // #if KW_TESTS_ENABLED
