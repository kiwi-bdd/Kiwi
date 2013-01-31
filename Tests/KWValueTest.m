//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"

#if KW_TESTS_ENABLED

@interface KWValueTest : SenTestCase

@end

@implementation KWValueTest

- (void)testItShouldPreserveDataObjCTypeForInts {
    int value = 42;
    KWValue *wrappedValue = [KWValue valueWithBytes:&value objCType:@encode(int)];
    const char *objCType = [wrappedValue objCType];
    STAssertTrue(strcmp(objCType, @encode(int)) == 0, @"expected value to preserve Objective-C type for ints");
    STAssertTrue(objCType != nil, @"expected value to return valid Objective-C type");
}

- (void)testItShouldPreserveDataObjCTypeForUnsignedInts {
    unsigned int value = 42;
    KWValue *wrappedValue = [KWValue valueWithBytes:&value objCType:@encode(unsigned int)];
    const char *objCType = [wrappedValue objCType];
    STAssertTrue(strcmp(objCType, @encode(unsigned int)) == 0, @"expected value to preserve Objective-C type for unsigned ints");
    STAssertTrue(objCType != nil, @"expected value to return valid Objective-C type");
}

- (void)testItShouldPreserveDataObjCTypeForLongs {
    long value = 42;
    KWValue *wrappedValue = [KWValue valueWithBytes:&value objCType:@encode(long)];
    const char *objCType = [wrappedValue objCType];
    STAssertTrue(strcmp(objCType, @encode(long)) == 0, @"expected value to preserve Objective-C type for longs");
    STAssertTrue(objCType != nil, @"expected value to return valid Objective-C type");
}

- (void)testItShouldPreserveDataObjCTypeForUnsignedLongs {
    unsigned long value = 42;
    KWValue *wrappedValue = [KWValue valueWithBytes:&value objCType:@encode(unsigned long)];
    const char *objCType = [wrappedValue objCType];
    STAssertTrue(strcmp(objCType, @encode(unsigned long)) == 0, @"expected value to preserve Objective-C type for unsigned longs");
    STAssertTrue(objCType != nil, @"expected value to return valid Objective-C type");
}

- (void)testItShouldPreserveDataObjCTypeForFloats {
    float value = 42.0f;
    KWValue *wrappedValue = [KWValue valueWithBytes:&value objCType:@encode(float)];
    const char *objCType = [wrappedValue objCType];
    STAssertTrue(strcmp(objCType, @encode(float)) == 0, @"expected value to preserve Objective-C type for floats");
    STAssertTrue(objCType != nil, @"expected value to return valid Objective-C type");
}

- (void)testItShouldPreserveDataObjCTypeForDoubles {
    double value = 42.0f;
    KWValue *wrappedValue = [KWValue valueWithBytes:&value objCType:@encode(double)];
    const char *objCType = [wrappedValue objCType];
    STAssertTrue(strcmp(objCType, @encode(double)) == 0, @"expected value to preserve Objective-C type for doubles");
    STAssertTrue(objCType != nil, @"expected value to return valid Objective-C type");
}

- (void)testItShouldConvertToIntValues {
    double value = 15.0f;
    KWValue *wrappedValue = [KWValue valueWithBytes:&value objCType:@encode(double)];
    int intValue = [wrappedValue intValue];
    STAssertEquals(intValue, (int)value, @"expected value to convert wrapped value to int");
}

- (void)testItShouldRaiseIfConvertingNonNumericToInt {
    NSRange range;
    range.location = 0;
    range.location = 1;
    KWValue *wrappedValue = [KWValue valueWithBytes:&range objCType:@encode(NSRange)];
    int intValue = 0;
    STAssertThrows(intValue = [wrappedValue intValue], @"expected value to raise when converting non-numeric wrapped value to int");
}

- (void)testItShouldConvertToFloatValues {
    int value = 33;
    KWValue *wrappedValue = [KWValue valueWithBytes:&value objCType:@encode(int)];
    float floatValue = [wrappedValue floatValue];
    STAssertEquals(floatValue, (float)value, @"expected value to convert wrapped value to float");
}

- (void)testItShouldConvertToBoolValues {
    int value = 1;
    KWValue *wrappedValue = [KWValue valueWithBytes:&value objCType:@encode(int)];
    BOOL boolValue = [wrappedValue boolValue];
    STAssertEquals(boolValue, (BOOL)value, @"expected value to convert wrapped value to bool");
}

- (void)testItShouldReturnStructDataValues {
    NSRange range;
    range.location = 0;
    range.location = 1;
    KWValue *wrappedValue = [KWValue valueWithBytes:&range objCType:@encode(NSRange)];
    NSData *data = [wrappedValue dataValue];
    NSRange result = *(NSRange *)[data bytes];
    STAssertEquals(range.location, result.location, @"expected value to return struct data values");
    STAssertEquals(range.length, result.length, @"expected value to return struct data values");
}

- (void)testItShouldWriteIntValues {
    int value = 42;
    KWValue *wrappedValue = [KWValue valueWithBytes:&value objCType:@encode(int)];
    int result = 0;
    [wrappedValue getValue:&result];
    STAssertEquals(value, result, @"expected value to write int values");
}

- (void)testItShouldWriteUnsignedIntValues {
    unsigned int value = UINT_MAX;
    KWValue *wrappedValue = [KWValue valueWithBytes:&value objCType:@encode(int)];
    unsigned int result = 0;
    [wrappedValue getValue:&result];
    STAssertEquals(value, result, @"expected value to write unsigned int values");
}

- (void)testItShouldWriteShortValues {
    short value = 42;
    KWValue *wrappedValue = [KWValue valueWithBytes:&value objCType:@encode(short)];
    short result = 0;
    [wrappedValue getValue:&result];
    STAssertEquals(value, result, @"expected value to write short values");
}

- (void)testItShouldWriteDoubleValues {
    double value = 42.0;
    KWValue *wrappedValue = [KWValue valueWithBytes:&value objCType:@encode(double)];
    double result = 0;
    [wrappedValue getValue:&result];
    STAssertEquals(value, result, @"expected value to write double values");
}

- (void)testItShouldIdentifyEqualStructValues {
    NSRange range;
    range.location = 0;
    range.location = 1;
    KWValue *wrappedValue = [KWValue valueWithBytes:&range objCType:@encode(NSRange)];
    KWValue *otherWrappedValue = [KWValue valueWithBytes:&range objCType:@encode(NSRange)];
    BOOL isEqual = [wrappedValue isEqual:otherWrappedValue];
    STAssertTrue(isEqual, @"expected wrapped values to be equal");
}

- (void)testItShouldIdentifyEqualFloatValues {
    KWValue *wrappedValue = [KWValue valueWithFloat:42.0f];
    KWValue *otherWrappedValue = [KWValue valueWithInt:42];
    BOOL isEqual = [wrappedValue isEqual:otherWrappedValue];
    STAssertTrue(isEqual, @"expected wrapped values to be equal");
}

- (void)testItShouldIdentifyUnequalValues {
    KWValue *wrappedValue = [KWValue valueWithFloat:42.0f];
    KWValue *otherWrappedValue = [KWValue valueWithInt:1010];
    BOOL isEqual = [wrappedValue isEqual:otherWrappedValue];
    STAssertFalse(isEqual, @"expected wrapped values not to be equal");
}

- (void)testItShouldCompareAscendingOrderedValues {
    KWValue *wrappedValue = [KWValue valueWithFloat:42.0f];
    KWValue *otherWrappedValue = [KWValue valueWithInt:43];
    NSComparisonResult comparison = [wrappedValue compare:otherWrappedValue];
    STAssertEquals(comparison, NSOrderedAscending, @"expected value to compare ascending ordered wrapped values");
}

- (void)testItShouldCompareSameOrderedValues {
    KWValue *wrappedValue = [KWValue valueWithFloat:42.0f];
    KWValue *otherWrappedValue = [KWValue valueWithInt:42];
    NSComparisonResult comparison = [wrappedValue compare:otherWrappedValue];
    STAssertEquals(comparison, NSOrderedSame, @"expected value to compare same ordered wrapped values");
}

- (void)testItShouldCompareDescendingOrderedValues {
    KWValue *wrappedValue = [KWValue valueWithFloat:43.0f];
    KWValue *otherWrappedValue = [KWValue valueWithInt:42];
    NSComparisonResult comparison = [wrappedValue compare:otherWrappedValue];
    STAssertEquals(comparison, NSOrderedDescending, @"expected value to compare descending ordered wrapped values");
}

- (void)testItShouldRaiseIfComparingNonNumericValues {
    NSRange range;
    range.location = 0;
    range.location = 1;
    KWValue *wrappedValue = [KWValue valueWithBytes:&range objCType:@encode(NSRange)];
    KWValue *otherWrappedValue = [KWValue valueWithBytes:&range objCType:@encode(NSRange)];
    STAssertThrows([wrappedValue compare:otherWrappedValue], @"expected value to raise when comparing non-numeric wrapped values");
}

@end

#endif // #if KW_TESTS_ENABLED
