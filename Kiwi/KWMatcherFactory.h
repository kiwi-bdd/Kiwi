//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"
#import "KWMatching.h"

@interface KWMatcherFactory : NSObject {
@private
    NSMutableArray *registeredMatcherClasses;
    NSMutableDictionary *matcherClassChains;
}

#pragma mark -
#pragma mark Initializing

- (id)init;

#pragma mark -
#pragma mark Properties

@property (nonatomic, readonly) NSArray *registeredMatcherClasses;

#pragma mark -
#pragma mark Registering Matcher Classes

- (void)registerMatcherClass:(Class)aClass;
- (void)registerMatcherClassesWithNamespacePrefix:(NSString *)aNamespacePrefix;

#pragma mark -
#pragma mark Getting Method Signatures

- (NSMethodSignature *)methodSignatureForMatcherSelector:(SEL)aSelector;

#pragma mark -
#pragma mark Getting Matcher Classes

- (Class)matcherClassForSelector:(SEL)aSelector subject:(id)anObject;

@end
