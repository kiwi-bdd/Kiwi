//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"

@class KWMessagePattern;

@interface KWStub : NSObject

#pragma mark -
#pragma mark Initializing

- (id)initWithMessagePattern:(KWMessagePattern *)aMessagePattern;
- (id)initWithMessagePattern:(KWMessagePattern *)aMessagePattern value:(id)aValue;
- (id)initWithMessagePattern:(KWMessagePattern *)aMessagePattern block:(id (^)(NSArray *params))aBlock;
- (id)initWithMessagePattern:(KWMessagePattern *)aMessagePattern value:(id)aValue times:(NSInteger)times afterThatReturn:(id)aSecondValue;

+ (id)stubWithMessagePattern:(KWMessagePattern *)aMessagePattern;
+ (id)stubWithMessagePattern:(KWMessagePattern *)aMessagePattern value:(id)aValue;
+ (id)stubWithMessagePattern:(KWMessagePattern *)aMessagePattern block:(id (^)(NSArray *params))aBlock;
+ (id)stubWithMessagePattern:(KWMessagePattern *)aMessagePattern value:(id)aValue times:(NSInteger)times afterThatReturn:(id)aSecondValue;

#pragma mark -
#pragma mark Properties

@property (nonatomic, strong, readonly) KWMessagePattern *messagePattern;
@property (nonatomic, strong, readonly) id value;
@property (nonatomic, assign, readonly) NSInteger returnValueTimes;
@property (nonatomic, assign, readonly) NSInteger returnedValueTimes;
@property (nonatomic, strong, readonly) id secondValue;
@property (nonatomic, copy, readonly) id (^block)(NSArray *params);

#pragma mark -
#pragma mark Processing Invocations

- (BOOL)processInvocation:(NSInvocation *)anInvocation;

@end
