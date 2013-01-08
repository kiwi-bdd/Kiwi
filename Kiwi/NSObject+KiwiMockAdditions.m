//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "NSObject+KiwiMockAdditions.h"
#import "KWMock.h"
#import "KWMockDescription.h"
#import <objc/runtime.h>

@implementation NSObject(KiwiMockAdditions)

#pragma mark -
#pragma mark Creating Mocks

+ (id)mock {
    return [KWMock mockForClass:[self class]];
}

+ (id)mockWithName:(NSString *)aName {
    return [KWMock mockWithName:aName forClass:[self class]];
}

+ (id)nullMock {
    return [KWMock nullMockForClass:[self class]];
}

+ (id)nullMockWithName:(NSString *)aName {
    return [KWMock nullMockWithName:aName forClass:[self class]];
}

#pragma mark -
#pragma mark Injecting Mocked Dependencies

static id mockedDependencyWithDescription(id self, NSString *dependencyName, KWMockDescription *mockDescription) {
	id existingDependency = [self valueForKey:dependencyName];
	if (![existingDependency respondsToSelector:@selector(isNullMock)])
        [self setValue:[KWMock mockWithDescription:mockDescription] forKey:dependencyName];

	return [self valueForKey:dependencyName];
}

static id mockedDependencyWithNullFlag(id self, NSString *dependencyName, BOOL nullFlag) {
    Ivar ivar = class_getInstanceVariable([self class], [dependencyName UTF8String]);
    if (!ivar) {
        NSString *reason = [NSString stringWithFormat:@"dependency '%@' was not found.", dependencyName];
        @throw [NSException exceptionWithName:@"KWMockException" reason:reason userInfo:nil];
    }
    const char* encoding = ivar_getTypeEncoding(ivar);
    return mockedDependencyWithDescription(
            self,
            dependencyName,
            [KWMockDescription null:nullFlag mockForTypeEncoding:encoding]
            );
}

- (id)mockFor:(NSString *)dependencyName {
    return mockedDependencyWithNullFlag(self, dependencyName, NO);
}

- (id)mockFor:(NSString *)dependencyName ofType:(Class)type {
    return mockedDependencyWithDescription(self, dependencyName, [KWMockDescription null:NO mockForClass:type]);
}

- (id)mockFor:(NSString *)dependencyName conformingToProtocol:(Protocol *)protocol {
    return mockedDependencyWithDescription(self, dependencyName, [KWMockDescription null:NO mockForProtocol:protocol]);
}

- (id)nullMockFor:(NSString *)dependencyName {
    return mockedDependencyWithNullFlag(self, dependencyName, YES);
}

- (id)nullMockFor:(NSString *)dependencyName ofType:(Class)type {
    return mockedDependencyWithDescription(self, dependencyName, [KWMockDescription null:YES mockForClass:type]);
}

- (id)nullMockFor:(NSString *)dependencyName conformingToProtocol:(Protocol *)protocol {
    return mockedDependencyWithDescription(self, dependencyName, [KWMockDescription null:YES mockForProtocol:protocol]);
}

@end
