//
// Licensed under the terms in License.txt
//
// Copyright 2012 Allen Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KWMockDescription : NSObject {
@private
    BOOL isNullMock;
    NSString *name;
    Class mockedClass;
    Protocol *mockedProtocol;
}

@property (nonatomic, readonly) BOOL isNullMock;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) Class mockedClass;
@property (nonatomic, readonly) Protocol *mockedProtocol;

+ (KWMockDescription *)null:(BOOL)isNull mockForClass:(Class)aClass;
+ (KWMockDescription *)null:(BOOL)isNull mockForProtocol:(Protocol *)aProtocol;
+ (KWMockDescription *)null:(BOOL)isNull mockNamed:(NSString *)aName forClass:(Class)aClass;
+ (KWMockDescription *)null:(BOOL)isNull mockNamed:(NSString *)aName forProtocol:(Protocol *)aProtocol;
+ (KWMockDescription *)null:(BOOL)isNull mockForTypeEncoding:(const char*)encoding;

@end

