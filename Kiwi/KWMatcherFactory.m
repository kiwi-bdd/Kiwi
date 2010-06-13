//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWMatcherFactory.h"
#import </usr/include/objc/runtime.h>
#import "KWMatching.h"
#import "KWStringUtilities.h"

@implementation KWMatcherFactory

#pragma mark -
#pragma mark Initializing

- (id)init {
    if ((self = [super init])) {
        matcherClassChains = [[NSMutableDictionary alloc] init];
        registeredMatcherClasses = [[NSMutableArray alloc] init];
    }

    return self;
}

- (void)dealloc {
    [matcherClassChains release];
    [super dealloc];
}

#pragma mark -
#pragma mark Properties

@synthesize registeredMatcherClasses;

#pragma mark -
#pragma mark Registering Matcher Classes

- (void)registerMatcherClass:(Class)aClass {
    if ([self.registeredMatcherClasses containsObject:aClass])
        return;

    [registeredMatcherClasses addObject:aClass];

    for (NSString *verificationSelectorString in [aClass matcherStrings]) {
        NSMutableArray *matcherClassChain = [matcherClassChains objectForKey:verificationSelectorString];

        if (matcherClassChain == nil) {
            matcherClassChain = [[NSMutableArray alloc] init];
            [matcherClassChains setObject:matcherClassChain forKey:verificationSelectorString];
            [matcherClassChain release];
        }

        [matcherClassChain removeObject:aClass];
        [matcherClassChain insertObject:aClass atIndex:0];
    }
}

- (void)registerMatcherClassesWithNamespacePrefix:(NSString *)aNamespacePrefix {
    static NSMutableArray *matcherClasses = nil;

    // Cache all classes that conform to KWMatching.
    if (matcherClasses == nil) {
        matcherClasses = [[NSMutableArray alloc] init];
        int numberOfClasses = objc_getClassList(NULL, 0);
        Class *classes = malloc(sizeof(Class) * numberOfClasses);
        numberOfClasses = objc_getClassList(classes, numberOfClasses);

        if (numberOfClasses == 0)
            return;

        for (int i = 0; i < numberOfClasses; ++i) {
            Class candidateClass = classes[i];

            if (!class_respondsToSelector(candidateClass, @selector(conformsToProtocol:)))
                continue;

            if (![candidateClass conformsToProtocol:@protocol(KWMatching)])
                continue;

            [matcherClasses addObject:candidateClass];
        }

        free(classes);
    }
    
    for (Class matcherClass in matcherClasses) {
        NSString *className = NSStringFromClass(matcherClass);
        
        if (KWStringHasStrictWordPrefix(className, aNamespacePrefix))
            [self registerMatcherClass:matcherClass];
    }
}

#pragma mark -
#pragma mark Getting Method Signatures

- (NSMethodSignature *)methodSignatureForMatcherSelector:(SEL)aSelector {
    NSMutableArray *matcherClassChain = [matcherClassChains objectForKey:NSStringFromSelector(aSelector)];

    if ([matcherClassChain count] == 0)
        return nil;

    Class matcherClass = [matcherClassChain objectAtIndex:0];
    return [matcherClass instanceMethodSignatureForSelector:aSelector];
}

#pragma mark -
#pragma mark Getting Matcher Classes

- (Class)matcherClassForSelector:(SEL)aSelector subject:(id)anObject {
    NSArray *matcherClassChain = [matcherClassChains objectForKey:NSStringFromSelector(aSelector)];
    
    for (Class matcherClass in matcherClassChain) {
        if ([matcherClass canMatchSubject:anObject])
            return matcherClass;
    }
    
    return nil;
}

@end
