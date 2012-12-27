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

- (id)initWithNullFlag:(BOOL)nullFlag name:(NSString *)aName mockedClass:(Class)aClass mockedProtocol:(Protocol *)aProtocol;

+ (KWMockDescription *)mockForClass:(Class)aClass;
+ (KWMockDescription *)mockForProtocol:(Protocol *)aProtocol;
+ (KWMockDescription *)mockNamed:(NSString *)aName forClass:(Class)aClass;
+ (KWMockDescription *)mockNamed:(NSString *)aName forProtocol:(Protocol *)aProtocol;

+ (KWMockDescription *)nullMockForClass:(Class)aClass;
+ (KWMockDescription *)nullMockForProtocol:(Protocol *)aProtocol;
@end

