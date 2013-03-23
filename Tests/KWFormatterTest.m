//
//  KWFormatterTest.m
//  Kiwi
//
//  Created by Marin Usalj on 3/23/13.
//  Copyright (c) 2013 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"

#if KW_TESTS_ENABLED

@interface KWFormatterTest : SenTestCase

@end

@implementation KWFormatterTest

- (void)testFormatsStringsWithQuotes {
    NSString *sampleString = @"sample";
    STAssertEqualObjects(@"\"sample\"", [KWFormatter formatObject:sampleString], @"String should be surrounded with quotes");
}

- (void)testFormatsEnumerableCollectionsInline {
    NSArray *sampleArray = @[@1, @2, @3];
    STAssertEqualObjects(@"(1, 2, 3)", [KWFormatter formatObject:sampleArray], @"Array objects should be formatted inline");
}

- (void)testFormatsDictionariesWithKeysAndValuesMultiline {
    NSDictionary *sampleDict = @{ @"foo" : @"bar",  @"baz" : @"bang" };
    STAssertEqualObjects([sampleDict description], [KWFormatter formatObject:sampleDict], @"Dictionaries should be not treated as NSEnumerable");
}

@end

#endif // #if KW_TESTS_ENABLED
