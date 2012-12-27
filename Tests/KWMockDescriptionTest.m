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

@end

#endif // #if KW_TESTS_ENABLED
