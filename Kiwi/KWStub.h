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
}

#pragma mark -
#pragma mark Initializing

- (id)initWithMessagePattern:(KWMessagePattern *)aMessagePattern;
- (id)initWithMessagePattern:(KWMessagePattern *)aMessagePattern value:(id)aValue;

+ (id)stubWithMessagePattern:(KWMessagePattern *)aMessagePattern;
+ (id)stubWithMessagePattern:(KWMessagePattern *)aMessagePattern value:(id)aValue;

#pragma mark -
#pragma mark Properties

@property (nonatomic, readonly) KWMessagePattern *messagePattern;
@property (nonatomic, readonly) id value;

#pragma mark -
#pragma mark Processing Invocations

- (BOOL)processInvocation:(NSInvocation *)anInvocation;

@end
