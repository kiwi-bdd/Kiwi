//
// Licensed under the terms in License.txt
//
// Copyright 2014 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "NSNumber+KiwiAdditions.h"

@interface NSNumber_KiwiAdditionsTests : XCTestCase

@end

@implementation NSNumber_KiwiAdditionsTests

#pragma mark numberWithBoolBytes

- (void)testNumberWithBoolBytesReturnsANumberFromBoolBytes {
    BOOL value = YES;
    NSNumber *number = [NSNumber numberWithBoolBytes:&value];
    XCTAssertEqualObjects(number, @1, @"Expected +numberWithBoolBytes: to convert YES to @1.");
}

#pragma mark numberWithStdBoolBytes

- (void)testNumberWithStdBoolBytesReturnsANumberFromStdBoolBytes {
    bool value = true;
    NSNumber *number = [NSNumber numberWithStdBoolBytes:&value];
    XCTAssertEqualObjects(number, @1, @"Expected +numberWithStdBoolBytes: to convert true to @1.");
}

@end
