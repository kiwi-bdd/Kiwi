//
// Licensed under the terms in License.txt
//
// Copyright 2014 Allen Ding. All rights reserved.
//

#import "NSInvocation+KWExample.h"
#import <objc/runtime.h>

const void * const kKWInvocationExampleKey = &kKWInvocationExampleKey;
const void * const kKWInvocationIsFirstExampleKey = &kKWInvocationIsFirstExampleKey;
const void * const kKWInvocationIsLastExampleKey = &kKWInvocationIsLastExampleKey;

@implementation NSInvocation (KWExampleGroup)

- (void)kw_setExample:(KWExample *)example {
    [self kw_setObject:example key:kKWInvocationExampleKey];
}

- (KWExample *)kw_example {
    return [self kw_objectForKey:kKWInvocationExampleKey];
}

- (void)kw_setIsFirstExample:(BOOL)isFirstExample {
    [self kw_setObject:@(isFirstExample) key:kKWInvocationIsFirstExampleKey];
}

- (BOOL)kw_isFirstExample {
    return [[self kw_objectForKey:kKWInvocationIsFirstExampleKey] boolValue];
}

- (void)kw_setIsLastExample:(BOOL)isLastExample {
    [self kw_setObject:@(isLastExample) key:kKWInvocationIsLastExampleKey];
}

- (BOOL)kw_isLastExample {
    return [[self kw_objectForKey:kKWInvocationIsLastExampleKey] boolValue];
}

#pragma mark - Internal Methods

- (void)kw_setObject:(id)object key:(const void *)key {
    objc_setAssociatedObject(self, key, object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)kw_objectForKey:(const void *)key {
    return objc_getAssociatedObject(self, key);
}

@end
