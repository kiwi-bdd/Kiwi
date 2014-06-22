//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"

#if KW_TESTS_ENABLED

@interface KWDeviceInfoTest : XCTestCase

@end

@implementation KWDeviceInfoTest

- (void)testItShouldDetectWhenRunningOnSimulator {
#if TARGET_IPHONE_SIMULATOR
    BOOL isSimulator = [KWDeviceInfo isSimulator];
    XCTAssertTrue(isSimulator, @"expected simulator device to be positive");
#else
    BOOL isSimulator = [KWDeviceInfo isSimulator];
    STAssertFalse(isSimulator, @"expected simulator device to be negative");
#endif // #if TARGET_IPHONE_SIMULATOR
}

- (void)testItShouldDetectWhenRunningOnDevice {
#if TARGET_IPHONE_SIMULATOR
    BOOL isPhysical = [KWDeviceInfo isPhysical];
    XCTAssertFalse(isPhysical, @"expected physical device to be negative");
#else
    BOOL isPhysical = [KWDeviceInfo isPhysical];
    STAssertTrue(isPhysical, @"expected physical device to be positive");
#endif // #if TARGET_IPHONE_SIMULATOR
}

@end

#endif // #if KW_TESTS_ENABLED
