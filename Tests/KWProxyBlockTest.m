//
//  KWProxyBlockTest.m
//  Kiwi
//
//  Created by Oleksa 'trimm' Korin on 4/18/16.
//  Copyright © 2016 Allen Ding. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "KiwiTestConfiguration.h"

#import "KWProxyBlock.h"

#if KW_TESTS_ENABLED


static const uint8_t KWTestStructValueCount = 4;

struct KWTestStruct {
    uint64_t values[KWTestStructValueCount];
};
typedef struct KWTestStruct KWTestStruct;

static
BOOL KWTestStructEqualsTestStruct(KWTestStruct struct1, KWTestStruct struct2) {
    for (uint8_t i = 0; i < KWTestStructValueCount; i++) {
        if (struct1.values[i] != struct2.values[i]) {
            return NO;
        }
    }
    
    return YES;
}

// test values
static const NSUInteger KWUIntValue = 1;
static NSString * const KWStringValue = @"mama";
static const KWTestStruct KWStructValue = (KWTestStruct){{1.0, 1.0, 1.0, 1.0}};

// test typedefs
typedef void(^__KWVoidBlock)(void);
typedef void(^__KWVoidBlockMultiparam)(NSUInteger, id, KWTestStruct);

typedef NSUInteger(^__KWPrimitiveBlock)(void);

typedef id(^__KWObjectBlock)(void);
typedef id(^__KWObjectBlockMultiparam)(NSUInteger, id, KWTestStruct);

typedef KWTestStruct(^__KWStretBlock)(void);
typedef KWTestStruct(^__KWStretBlockMultiparam)(NSUInteger, id, KWTestStruct);

@interface KWProxyBlockTest : XCTestCase

- (void)assertCorrectParamsWithUInteger:(NSUInteger)intValue object:(id)object structure:(KWTestStruct)rect;

@end

@implementation KWProxyBlockTest {
    __block BOOL _evaluated;
}

- (void)setUp {
    [super setUp];
    
    _evaluated = NO;
}

- (void)tearDown {
    XCTAssertTrue(_evaluated, "wrapped block wasn't evaluated");
    
    [super tearDown];
}

#pragma mark - Test block without parameters

- (void)testItShouldEvaluateWrappedVoidBlock {
    __KWVoidBlock block = ^{ _evaluated = YES; };
    
    KWProxyBlock *wrappedBlock = [KWProxyBlock blockWithBlock:block];
    
    ((__KWVoidBlock)wrappedBlock)();
}

- (void)testItShouldEvaluateWrappedPrimitiveBlock {
    __KWPrimitiveBlock block = ^{
        _evaluated = YES;
        
        return KWUIntValue;
    };
    
    KWProxyBlock *wrappedBlock = [KWProxyBlock blockWithBlock:block];
    
    XCTAssertEqual(KWUIntValue, ((__KWPrimitiveBlock)wrappedBlock)(), "wrapped block didn't return a proper value");
}

- (void)testItShouldEvaluateWrappedObjectBlock {
    __KWObjectBlock block = ^{
        _evaluated = YES;
        
        return KWStringValue;
    };
    
    KWProxyBlock *wrappedBlock = [KWProxyBlock blockWithBlock:block];
    
    XCTAssertEqualObjects(KWStringValue, ((__KWObjectBlock)wrappedBlock)(), "wrapped block didn't return a proper value");
}

- (void)testItShouldEvaluateWrappedStretBlock {
    __KWStretBlock block = ^{
        _evaluated = YES;
        
        return KWStructValue;
    };
    
    KWProxyBlock *wrappedBlock = [KWProxyBlock blockWithBlock:block];
    
    XCTAssertTrue(KWTestStructEqualsTestStruct(KWStructValue, ((__KWStretBlock)wrappedBlock)()),
                  "wrapped block didn't return a proper value");
}

#pragma mark - Test block with parameters

- (void)testItShouldEvaluateWrappedVoidBlockWithMultipleParameters {
    __KWVoidBlockMultiparam block = ^(NSUInteger intValue, id object, KWTestStruct rect) {
        [self assertCorrectParamsWithUInteger:intValue object:object structure:rect];
    };
    
    KWProxyBlock *wrappedBlock = [KWProxyBlock blockWithBlock:block];
    
    ((__KWVoidBlockMultiparam)wrappedBlock)(KWUIntValue, KWStringValue, KWStructValue);
}

- (void)testItShouldEvaluateWrappedObjectBlockWithMultipleParameters {
    __KWObjectBlockMultiparam block = ^(NSUInteger intValue, id object, KWTestStruct rect) {
        [self assertCorrectParamsWithUInteger:intValue object:object structure:rect];
        
        return KWStringValue;
    };
    
    KWProxyBlock *wrappedBlock = [KWProxyBlock blockWithBlock:block];
    
    id object = ((__KWObjectBlockMultiparam)wrappedBlock)(KWUIntValue, KWStringValue, KWStructValue);
    
    XCTAssertEqualObjects(KWStringValue, object, "wrapped block didn't return a proper value");
}

- (void)testItShouldEvaluateWrappedStretBlockWithMultipleParameters {
    __KWStretBlockMultiparam block = ^(NSUInteger intValue, id object, KWTestStruct rect) {
        [self assertCorrectParamsWithUInteger:intValue object:object structure:rect];
        
        return KWStructValue;
    };
    
    KWProxyBlock *wrappedBlock = [KWProxyBlock blockWithBlock:block];
    
    KWTestStruct rect = ((__KWStretBlockMultiparam)wrappedBlock)(KWUIntValue, KWStringValue, KWStructValue);
    
    XCTAssertTrue(KWTestStructEqualsTestStruct(KWStructValue, rect), "wrapped block didn't return a proper value");
}


- (void)assertCorrectParamsWithUInteger:(NSUInteger)intValue object:(id)object structure:(KWTestStruct)rect {
    _evaluated = YES;
    
    XCTAssertTrue(KWTestStructEqualsTestStruct(KWStructValue, rect), "wrapped block didn't return a proper value");
    XCTAssertEqualObjects(KWStringValue, object, "wrapped block didn't return a proper value");
    XCTAssertEqual(KWUIntValue, intValue, "wrapped block didn't return a proper value");
}

@end

#endif