//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWIntercept.h"
#import "KWMessagePattern.h"
#import "KWMessageSpying.h"
#import "KWStub.h"

static const char * const KWInterceptClassSuffix = "_KWIntercept";
static NSMutableDictionary *KWObjectStubs = nil;
static NSMutableDictionary *KWMessageSpies = nil;

#pragma mark -
#pragma mark Intercept Enabled Method Implementations

void KWInterceptedForwardInvocation(id anObject, SEL aSelector, NSInvocation* anInvocation);
void KWInterceptedDealloc(id anObject, SEL aSelector);
Class KWInterceptedClass(id anObject, SEL aSelector);
Class KWInterceptedSuperclass(id anObject, SEL aSelector);

#pragma mark -
#pragma mark Getting Forwarding Implementations

IMP KWRegularForwardingImplementation(void) {
    return class_getMethodImplementation([NSObject class], @selector(KWNonExistantSelector));
}

IMP KWStretForwardingImplementation(void) {
    return class_getMethodImplementation_stret([NSObject class], @selector(KWNonExistantSelector));
}

IMP KWForwardingImplementationForMethodEncoding(const char* encoding) {
#if TARGET_CPU_ARM
    const NSUInteger stretLengthThreshold = 4;
#elif TARGET_CPU_X86
    const NSUInteger stretLengthThreshold = 8;
#else
    // TODO: This just makes an assumption right now. Expand to support all
    // official architectures correctly.
    const NSUInteger stretLengthThreshold = 8;
#endif // #if TARGET_CPU_ARM

    NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:encoding];

    if (*[signature methodReturnType] == '{' && [signature methodReturnLength] > stretLengthThreshold) {
        NSLog(@"Warning: The Objective-C runtime appears to have bugs when forwarding messages with certain struct layouts as return types, so if a crash occurs this could be the culprit");
        return KWStretForwardingImplementation();
    } else {
        return KWRegularForwardingImplementation();
    }
}

#pragma mark -
#pragma mark Getting Intercept Class Information

BOOL KWObjectIsClass(id anObject) {
    return class_isMetaClass(object_getClass(anObject));
}

BOOL KWClassIsInterceptClass(Class aClass) {
    const char *name = class_getName(aClass);
    char *result = strstr(name, KWInterceptClassSuffix);
    return result != nil;
}

NSString *KWInterceptClassNameForClass(Class aClass) {
    const char *className = class_getName(aClass);
    return [NSString stringWithFormat:@"%s%s", className, KWInterceptClassSuffix];
}

Class KWInterceptClassForCanonicalClass(Class canonicalClass) {
    NSString *interceptClassName = KWInterceptClassNameForClass(canonicalClass);
    Class interceptClass = NSClassFromString(interceptClassName);

    if (interceptClass != nil)
        return interceptClass;

    interceptClass = objc_allocateClassPair(canonicalClass, [interceptClassName UTF8String], 0);
    objc_registerClassPair(interceptClass);

    class_addMethod(interceptClass, @selector(forwardInvocation:), (IMP)KWInterceptedForwardInvocation, "v@:@");
    class_addMethod(interceptClass, @selector(dealloc), (IMP)KWInterceptedDealloc, "v@:");
    class_addMethod(interceptClass, @selector(class), (IMP)KWInterceptedClass, "#@:");
    class_addMethod(interceptClass, @selector(superclass), (IMP)KWInterceptedSuperclass, "#@:");

    Class interceptMetaClass = object_getClass(interceptClass);
    class_addMethod(interceptMetaClass, @selector(forwardInvocation:), (IMP)KWInterceptedForwardInvocation, "v@:@");

    return interceptClass;
}

Class KWRealClassForClass(Class aClass) {
    if (KWClassIsInterceptClass(aClass))
        return [aClass superclass];

    return aClass;
}

#pragma mark -
#pragma mark Enabling Intercepting

static BOOL IsTollFreeBridged(Class class, id obj)
{
    // this is a naive check, but good enough for the purposes of failing fast
    return [NSStringFromClass(class) hasPrefix:@"NSCF"];
}

// Canonical class is the non-intercept, non-metaclass, class for an object.
//
// (e.g. [Animal class] would be canonical, not
// object_getClass([Animal class]), if the Animal class has not been touched
// by the intercept mechanism.

Class KWSetupObjectInterceptSupport(id anObject) {
    Class objectClass = object_getClass(anObject);

    if (IsTollFreeBridged(objectClass, anObject)) {
        [NSException raise:@"KWTollFreeBridgingInterceptException" format:@"Attempted to stub object of class %@. Kiwi does not support setting expectation or stubbing methods on toll-free bridged objects.", NSStringFromClass(objectClass)];
    }

    if (KWClassIsInterceptClass(objectClass))
        return objectClass;

    BOOL objectIsClass = KWObjectIsClass(anObject);
    Class canonicalClass =  objectIsClass ? anObject : objectClass;
    Class canonicalInterceptClass = KWInterceptClassForCanonicalClass(canonicalClass);
    Class interceptClass = objectIsClass ? object_getClass(canonicalInterceptClass) : canonicalInterceptClass;

    object_setClass(anObject, interceptClass);

    return interceptClass;
}

void KWSetupMethodInterceptSupport(Class interceptClass, SEL aSelector) {
    BOOL isMetaClass = class_isMetaClass(interceptClass);
    Method method = isMetaClass ? class_getClassMethod(interceptClass, aSelector)
                                : class_getInstanceMethod(interceptClass, aSelector);

    if (method == nil) {
        [NSException raise:NSInvalidArgumentException format:@"cannot setup intercept support for -%@ because there is no such method exists",
                                                             NSStringFromSelector(aSelector)];
    }

    const char *encoding = method_getTypeEncoding(method);
    IMP forwardingImplementation = KWForwardingImplementationForMethodEncoding(encoding);
    class_addMethod(interceptClass, aSelector, forwardingImplementation, encoding);
}

#pragma mark -
#pragma mark Intercept Enabled Method Implementations

void KWInterceptedForwardInvocation(id anObject, SEL aSelector, NSInvocation* anInvocation) {
    NSValue *key = [NSValue valueWithNonretainedObject:anObject];
    NSMutableDictionary *spyArrayDictionary = [KWMessageSpies objectForKey:key];

    for (KWMessagePattern *messagePattern in spyArrayDictionary) {
        if ([messagePattern matchesInvocation:anInvocation]) {
            NSArray *spies = [spyArrayDictionary objectForKey:messagePattern];

            for (NSValue *spyWrapper in spies) {
                id<KWMessageSpying> spy = [spyWrapper nonretainedObjectValue];
                [spy object:anObject didReceiveInvocation:anInvocation];
            }
        }
    }

    NSMutableArray *stubs = [KWObjectStubs objectForKey:key];

    for (KWStub *stub in stubs) {
        if ([stub processInvocation:anInvocation])
            return;
    }

    Class interceptClass = object_getClass(anObject);
    Class originalClass = class_getSuperclass(interceptClass);
    anObject->isa = originalClass;
    [anInvocation invoke];
    anObject->isa = interceptClass;
}

void KWInterceptedDealloc(id anObject, SEL aSelector) {
    NSValue *key = [NSValue valueWithNonretainedObject:anObject];
    [KWMessageSpies removeObjectForKey:key];
    [KWObjectStubs removeObjectForKey:key];

    Class interceptClass = object_getClass(anObject);
    Class originalClass = class_getSuperclass(interceptClass);
    anObject->isa = originalClass;
    [anObject dealloc];
}

Class KWInterceptedClass(id anObject, SEL aSelector) {
    Class interceptClass = object_getClass(anObject);
    Class originalClass = class_getSuperclass(interceptClass);
    return originalClass;
}

Class KWInterceptedSuperclass(id anObject, SEL aSelector) {
    Class interceptClass = object_getClass(anObject);
    Class originalClass = class_getSuperclass(interceptClass);
    Class originalSuperclass = class_getSuperclass(originalClass);
    return originalSuperclass;
}

#pragma mark -
#pragma mark Managing Objects Stubs

void KWAssociateObjectStub(id anObject, KWStub *aStub) {
    if (KWObjectStubs == nil)
        KWObjectStubs = [[NSMutableDictionary alloc] init];

    NSValue *key = [NSValue valueWithNonretainedObject:anObject];
    NSMutableArray *stubs = [KWObjectStubs objectForKey:key];

    if (stubs == nil) {
        stubs = [[NSMutableArray alloc] init];
        [KWObjectStubs setObject:stubs forKey:key];
        [stubs release];
    }

    NSUInteger stubCount = [stubs count];

    for (int i = 0; i < stubCount; ++i) {
        KWStub *existingStub = [stubs objectAtIndex:i];

        if ([aStub.messagePattern isEqualToMessagePattern:existingStub.messagePattern]) {
            [stubs removeObjectAtIndex:i];
            break;
        }
    }

    [stubs addObject:aStub];
}

void KWClearObjectStubs(id anObject) {
    NSValue *key = [NSValue valueWithNonretainedObject:anObject];
    [KWObjectStubs removeObjectForKey:key];
}

void KWClearAllObjectStubs(void) {
    [KWObjectStubs removeAllObjects];
}

#pragma mark -
#pragma mark Managing Message Spies

void KWAssociateMessageSpy(id anObject, id aSpy, KWMessagePattern *aMessagePattern) {
    if (KWMessageSpies == nil)
        KWMessageSpies = [[NSMutableDictionary alloc] init];

    NSValue *key = [NSValue valueWithNonretainedObject:anObject];
    NSMutableDictionary *spies = [KWMessageSpies objectForKey:key];

    if (spies == nil) {
        spies = [[NSMutableDictionary alloc] init];
        [KWMessageSpies setObject:spies forKey:key];
        [spies release];
    }

    NSMutableArray *messagePatternSpies = [spies objectForKey:aMessagePattern];

    if (messagePatternSpies == nil) {
        messagePatternSpies = [[NSMutableArray alloc] init];
        [spies setObject:messagePatternSpies forKey:aMessagePattern];
        [messagePatternSpies release];
    }

    NSValue *spyWrapper = [NSValue valueWithNonretainedObject:aSpy];

    if ([messagePatternSpies containsObject:spyWrapper])
        return;

    [messagePatternSpies addObject:spyWrapper];
}

void KWClearObjectSpy(id anObject, id aSpy, KWMessagePattern *aMessagePattern) {
    NSValue *key = [NSValue valueWithNonretainedObject:anObject];
    NSMutableDictionary *spyArrayDictionary = [KWMessageSpies objectForKey:key];
    NSMutableArray *spies = [spyArrayDictionary objectForKey:aMessagePattern];
    NSValue *spyWrapper = [NSValue valueWithNonretainedObject:aSpy];
    [spies removeObject:spyWrapper];
}

void KWClearAllMessageSpies(void) {
    [KWMessageSpies removeAllObjects];
}
