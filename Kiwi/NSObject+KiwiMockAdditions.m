//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "NSObject+KiwiMockAdditions.h"
#import "KWMock.h"
#import "KWMockDescription.h"

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

- (id)mockFor:(NSString *)dependencyName ofType:(Class)type {
	return mockedDependencyWithDescription(self, dependencyName, [KWMockDescription mockForClass:type]);
}

- (id)mockFor:(NSString *)dependencyName conformingToProtocol:(Protocol *)protocol {
	return mockedDependencyWithDescription(self, dependencyName, [KWMockDescription mockForProtocol:protocol]);
}

- (id)nullMockFor:(NSString *)dependencyName ofType:(Class)type {
	return mockedDependencyWithDescription(self, dependencyName, [KWMockDescription nullMockForClass:type]);
}

- (id)nullMockFor:(NSString *)dependencyName conformingToProtocol:(Protocol *)protocol {
	return mockedDependencyWithDescription(self, dependencyName, [KWMockDescription nullMockForProtocol:protocol]);
}

@end
