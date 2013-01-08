//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"

@interface NSObject(KiwiMockAdditions)

#pragma mark -
#pragma mark Creating Mocks

+ (id)mock;
+ (id)mockWithName:(NSString *)aName;

+ (id)nullMock;
+ (id)nullMockWithName:(NSString *)aName;

#pragma mark -
#pragma mark Injecting Mocked Dependencies

- (id)mockFor:(NSString *)dependencyName;
- (id)mockFor:(NSString *)dependencyName ofType:(Class)type;
- (id)mockFor:(NSString *)dependencyName conformingToProtocol:(Protocol *)protocol;

- (id)nullMockFor:(NSString *)dependencyName;
- (id)nullMockFor:(NSString *)dependencyName ofType:(Class)type;
- (id)nullMockFor:(NSString *)dependencyName conformingToProtocol:(Protocol *)protocol;

@end
