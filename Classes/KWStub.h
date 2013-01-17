//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"

@class KWMessagePattern;

@interface KWStub : NSObject {
@private
    KWMessagePattern *messagePattern;
    id value;
    id returnValueTimes;
    int returnedValueTimes;
    id secondValue;
	id (^block)(NSArray *params);
}

#pragma mark -
#pragma mark Initializing

- (id)initWithMessagePattern:(KWMessagePattern *)aMessagePattern;
- (id)initWithMessagePattern:(KWMessagePattern *)aMessagePattern value:(id)aValue;
- (id)initWithMessagePattern:(KWMessagePattern *)aMessagePattern block:(id (^)(NSArray *params))aBlock;
- (id)initWithMessagePattern:(KWMessagePattern *)aMessagePattern value:(id)aValue times:(id)times afterThatReturn:(id)aSecondValue;

+ (id)stubWithMessagePattern:(KWMessagePattern *)aMessagePattern;
+ (id)stubWithMessagePattern:(KWMessagePattern *)aMessagePattern value:(id)aValue;
+ (id)stubWithMessagePattern:(KWMessagePattern *)aMessagePattern block:(id (^)(NSArray *params))aBlock;
+ (id)stubWithMessagePattern:(KWMessagePattern *)aMessagePattern value:(id)aValue times:(id)times afterThatReturn:(id)aSecondValue;

#pragma mark -
#pragma mark Properties

@property (nonatomic, readonly) KWMessagePattern *messagePattern;
@property (nonatomic, readonly) id value;
@property (nonatomic, readonly) id returnValueTimes;
@property (nonatomic, readonly) int returnedValueTimes;
@property (nonatomic, readonly) id secondValue;

#pragma mark -
#pragma mark Processing Invocations

- (BOOL)processInvocation:(NSInvocation *)anInvocation;

@end
