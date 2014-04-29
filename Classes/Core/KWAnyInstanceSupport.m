//
//  KWFutureInstanceAttacher.m
//  Kiwi
//
//  Created by Jerry Marino on 3/12/14.
//  Copyright (c) 2014 Allen Ding. All rights reserved.
//

#import "KWAnyInstanceSupport.h"
#import <objc/runtime.h>
#import "KWVerifying.h"
#import "KWExampleSuiteBuilder.h"
#import "KWExample.h"
#import "KWCallSite.h"
#import "NSInvocation+KiwiAdditions.h"
#import "NSMethodSignature+KiwiAdditions.h"
#import "KWStringUtilities.h"   

@interface KWFutureInstanceAttacher ()

@property (nonatomic, assign) id <KWVerifying>verifier;
@property (nonatomic) NSMutableArray *invocations;

@end

@implementation KWFutureInstanceAttacher

@synthesize subject;

- (id)init {
    if (self = [super init]) {
        _invocations = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Attaching to Verifiers

- (id)attachToVerifier:(id<KWVerifying>)aVerifier {
    self.verifier = aVerifier;
    return self;
}

- (void)addInstance:(id)anInstance {
    id <KWVerifying> aVerifier = self.verifier;
    [anInstance attachToVerifier:aVerifier];

    NSInvocation *setupInvocation = self.invocations.firstObject;
    [(id)aVerifier forwardInvocation:setupInvocation];
}

#pragma mark - KWVerifying

- (NSString *)descriptionForAnonymousItNode {
    return nil;
}

- (void)exampleWillEnd {
}

#pragma mark - Handling Invocations

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    [self.invocations addObject:anInvocation];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];

    if (signature != nil)
        return signature;
    signature = [(NSObject *)self.verifier methodSignatureForSelector:aSelector];
    if (signature != nil)
        return signature;

    NSString *encoding = KWEncodingForDefaultMethod();
    return [NSMethodSignature signatureWithObjCTypes:[encoding UTF8String]];
}

@end

@implementation NSObject (KWAnyInstanceSupport)

static NSMutableSet *KWAttachedClasseses;
static NSMutableDictionary *KWFutureInstanceAttachersByClassName;
static NSMutableDictionary *KWOriginalAllocWithZoneByClassName;

+ (void)load {
    KWFutureInstanceAttachersByClassName = [[NSMutableDictionary alloc] init];
    KWAttachedClasseses = [[NSMutableSet alloc] init];
    KWOriginalAllocWithZoneByClassName = [[NSMutableDictionary alloc] init];
}

void KWClearFutureInstanceAttachment(void) {
    const SEL allocSel = @selector(allocWithZone:);
    [KWOriginalAllocWithZoneByClassName enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        Class originalClass = NSClassFromString(key);
        Method origMethod = class_getClassMethod(originalClass, allocSel);
        class_replaceMethod(originalClass, allocSel, [obj pointerValue], method_getTypeEncoding(origMethod));
    }];

    [KWAttachedClasseses removeAllObjects];
    [KWFutureInstanceAttachersByClassName removeAllObjects];
    [KWOriginalAllocWithZoneByClassName removeAllObjects];
}

+ (id)anyInstance {
    Class receiverClass = object_getClass([self class]);
    if (![KWAttachedClasseses containsObject:receiverClass]) {
        [self swizzleAllocForAllocatedInstanceAttacmentIfNecessary];
        [KWAttachedClasseses addObject:receiverClass];
    }

    KWFutureInstanceAttacher *attacher = [[KWFutureInstanceAttacher alloc] init];
    NSString *receiverClassName = NSStringFromClass(receiverClass);
    NSMutableArray *attachers = KWFutureInstanceAttachersByClassName[receiverClassName];
    if (!attachers) {
        attachers = [NSMutableArray array];
        KWFutureInstanceAttachersByClassName[receiverClassName] = attachers;
    }
    
    [attachers addObject:attacher];
    return attacher;
}

+ (void)swizzleAllocForAllocatedInstanceAttacmentIfNecessary {
    Class receiverClass = object_getClass([self class]);
    if ([KWAttachedClasseses containsObject:receiverClass])
        return;
    
    const SEL origSel = @selector(allocWithZone:);
    Method origMethod = class_getClassMethod(receiverClass, origSel);
    IMP originalIMP = method_getImplementation(origMethod);
    KWOriginalAllocWithZoneByClassName[NSStringFromClass(receiverClass)] = [NSValue valueWithPointer:originalIMP];
    
    IMP newImp = imp_implementationWithBlock(^(id _self, NSZone *z){
        id instance = originalIMP(_self, origSel, z);
        KWAddVerifyingForAnyInstance(instance);
        return instance;
    });
    
    class_replaceMethod(receiverClass, origSel, newImp, method_getTypeEncoding(origMethod));
}

static void KWAddVerifyingForAnyInstance(id anInstance){
    NSArray *attachers = KWFutureInstanceAttachersByClassName[NSStringFromClass([anInstance class])];
    [attachers makeObjectsPerformSelector:@selector(addInstance:) withObject:anInstance];
}

@end
