//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "NSObject+KiwiMockAdditions.h"
#import "KWMock.h"

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

static void ensureDependencyIsAMock(id self, NSString *dependencyName, id newMock) {
	id existingDependency = [self valueForKey:dependencyName];
	if (![existingDependency respondsToSelector:@selector(isNullMock)])
		[self setValue:newMock forKey:dependencyName];
}

- (id)mockFor:(NSString *)dependencyName ofType:(Class)type {
	ensureDependencyIsAMock(self, dependencyName, [KWMock mockForClass:type]);
	return [self valueForKey:dependencyName];
}

- (id)mockFor:(NSString *)dependencyName conformingToProtocol:(Protocol *)protocol {
	ensureDependencyIsAMock(self, dependencyName, [KWMock mockForProtocol:protocol]);
	return [self valueForKey:dependencyName];
}

- (id)nullMockFor:(NSString *)dependencyName ofType:(Class)type {
	ensureDependencyIsAMock(self, dependencyName, [KWMock nullMockForClass:type]);
	return [self valueForKey:dependencyName];
}

@end
