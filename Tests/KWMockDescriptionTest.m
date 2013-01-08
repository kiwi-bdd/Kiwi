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
            [KWMockDescription mockForTypeEncoding:"@\"Cruiser\""],
            [KWMockDescription mockForClass:[Cruiser class]],
            @"expected parsing '@\"Cruiser\"' to return a description which would mock Cruiser"
            );
}

- (void)testItShouldProduceAnNSObjectMockForAnIdSignature {
    STAssertEqualObjects(
            [KWMockDescription mockForTypeEncoding:"@"],
           [KWMockDescription mockForClass:[NSObject class]],
           @"expected parsing '@' to return a description which would mock NSObject"
           );
}

@end

#endif // #if KW_TESTS_ENABLED
