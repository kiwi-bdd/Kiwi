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

- (id)mockForDependency:(NSString *)dependencyName ofType:(Class)type {
	id existingMock = [self valueForKey:dependencyName];
	if ([existingMock respondsToSelector:@selector(isNullMock)])
		return existingMock;

	id mock = [KWMock mockForClass:type];
	[self setValue:mock forKey:dependencyName];
	return mock;
}

- (id)nullMockForDependency:(NSString *)dependencyName ofType:(Class)type {
	id existingMock = [self valueForKey:dependencyName];
	if ([existingMock respondsToSelector:@selector(isNullMock)])
		return existingMock;

	id nullMock = [KWMock nullMockForClass:type];
	[self setValue:nullMock forKey:dependencyName];
	return nullMock;
}

@end
