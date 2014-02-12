//
// Licensed under the terms in License.txt
//
// Copyright 2014 Allen Ding. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "NSObject+KWStringRepresentation.h"

@interface NSObject_KWStringRepresentation : SenTestCase

@end

@implementation NSObject_KWStringRepresentation

- (void)testRepresentationOfStringsWithQuotes {
    NSString *sampleString = @"sample";
    STAssertEqualObjects(@"\"sample\"",
                         [sampleString kw_stringRepresentation],
                         @"String should be surrounded with quotes");
}

- (void)testRepresentationOfEnumerableCollectionsInline {
    NSArray *sampleArray = @[@1, @2, @3];
    STAssertEqualObjects(@"(1, 2, 3)",
                         [sampleArray kw_stringRepresentation],
                         @"Array objects should be formatted inline");
}

- (void)testRepresentationOfDictionariesWithKeysAndValuesMultiline {
    NSDictionary *sampleDict = @{ @"foo" : @"bar",  @"baz" : @"bang" };
    STAssertEqualObjects([sampleDict description],
                         [sampleDict kw_stringRepresentation],
                         @"Dictionaries should be not treated as NSEnumerable");
}

- (void)testRepresentationWithClassOfString {
    NSString *sampleString = @"another sample";
    STAssertEqualObjects(@"(NSString) \"another sample\"",
                         [sampleString kw_stringRepresentationWithClass],
                         @"String class should also be represented");
}

@end
