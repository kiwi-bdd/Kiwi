//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"
#import "KWInvocationCapturer.h"

@class KWMessagePattern;

@protocol KWMessageSpying;
@protocol KWVerifying;

@interface KWMock : NSObject {
@private
    BOOL isNullMock;
    NSString *name;
    Class mockedClass;
    Protocol *mockedProtocol;
    NSMutableArray *stubs;
    NSMutableArray *expectedMessagePatterns;
    NSMutableDictionary *messageSpies;
}

#pragma mark -
#pragma mark Initializing

- (id)initForClass:(Class)aClass;
- (id)initForProtocol:(Protocol *)aProtocol;
- (id)initWithName:(NSString *)aName forClass:(Class)aClass;
- (id)initWithName:(NSString *)aName forProtocol:(Protocol *)aProtocol;

- (id)initAsNullMockForClass:(Class)aClass;
- (id)initAsNullMockForProtocol:(Protocol *)aProtocol;
- (id)initAsNullMockWithName:(NSString *)aName forClass:(Class)aClass;
- (id)initAsNullMockWithName:(NSString *)aName forProtocol:(Protocol *)aProtocol;

+ (id)mockForClass:(Class)aClass;
+ (id)mockForProtocol:(Protocol *)aProtocol;
+ (id)mockWithName:(NSString *)aName forClass:(Class)aClass;
+ (id)mockWithName:(NSString *)aName forProtocol:(Protocol *)aProtocol;

+ (id)nullMockForClass:(Class)aClass;
+ (id)nullMockForProtocol:(Protocol *)aProtocol;
+ (id)nullMockWithName:(NSString *)aName forClass:(Class)aClass ;
+ (id)nullMockWithName:(NSString *)aName forProtocol:(Protocol *)aProtocol;

#pragma mark -
#pragma mark Properties

@property (nonatomic, readonly) BOOL isNullMock;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) Class mockedClass;
@property (nonatomic, readonly) Protocol *mockedProtocol;

#pragma mark -
#pragma mark Stubbing Methods

- (void)stub:(SEL)aSelector;
- (void)stub:(SEL)aSelector withArguments:(id)firstArgument, ...;
- (void)stub:(SEL)aSelector andReturn:(id)aValue;
- (void)stub:(SEL)aSelector andReturn:(id)aValue withArguments:(id)firstArgument, ...;

- (id)stub;
- (id)stubAndReturn:(id)aValue;

- (void)stubMessagePattern:(KWMessagePattern *)aMessagePattern andReturn:(id)aValue;

- (void)clearStubs;

#pragma mark -
#pragma mark Spying on Messages

- (void)addMessageSpy:(id<KWMessageSpying>)aSpy forMessagePattern:(KWMessagePattern *)aMessagePattern;
- (void)removeMessageSpy:(id<KWMessageSpying>)aSpy forMessagePattern:(KWMessagePattern *)aMessagePattern;

#pragma mark -
#pragma mark Expecting Messages

- (void)expect:(SEL)aSelector;
- (void)expect:(SEL)aSelector withArguments:(id)firstArgument, ...;

- (id)expect;

- (void)expectMessagePattern:(KWMessagePattern *)aMessagePattern;

@end
