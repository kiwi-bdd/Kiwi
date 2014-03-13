//
//  KWFutureInstanceAttacher.m
//  Kiwi
//
//  Created by Jerry Marino on 3/12/14.
//  Copyright (c) 2014 Allen Ding. All rights reserved.
//

#import "KWFutureInstanceAttacher.h"
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
@property (nonatomic, retain) NSMutableArray *invocations;

@end

@implementation KWFutureInstanceAttacher

@synthesize subject;

- (id)init {
    if (self = [super init]) {
        _invocations = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    [_invocations makeObjectsPerformSelector:@selector(release)];
    [_invocations release];
    [super dealloc];
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
    [self.invocations addObject:[anInvocation retain]];
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
static NSMutableDictionary *KWFutureInstanceAttachersByClass;
static NSMutableDictionary *KWAllocatedClassByAnyInstanceReceiver;
static NSMutableDictionary *KWOriginalAllocByClass;
static NSMutableDictionary *KWOriginalInitByClass;

+ (void)load {
    KWFutureInstanceAttachersByClass = [[[NSMutableDictionary alloc] init] retain];
    KWAttachedClasseses = [[[NSMutableSet alloc] init] retain];
    KWAllocatedClassByAnyInstanceReceiver = [[[NSMutableDictionary alloc] init] retain];
    KWOriginalAllocByClass = [[[NSMutableDictionary alloc] init] retain];
    KWOriginalInitByClass = [[[NSMutableDictionary alloc] init] retain];
}

void KWClearFutureInstanceAttachment(void) {
    const SEL allocSel = @selector(alloc);
    [KWOriginalAllocByClass enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        Method origMethod = class_getClassMethod(key, allocSel);
        class_replaceMethod(key, allocSel, [obj pointerValue], method_getTypeEncoding(origMethod));
    }];
    
    const SEL initSel = @selector(init);
    [KWOriginalInitByClass enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        Method origMethod = class_getInstanceMethod(key, initSel);
        class_replaceMethod(key, initSel, [obj pointerValue], method_getTypeEncoding(origMethod));
    }];

    [KWAttachedClasseses removeAllObjects];
    [KWFutureInstanceAttachersByClass removeAllObjects];
    [KWAllocatedClassByAnyInstanceReceiver removeAllObjects];
    [KWOriginalAllocByClass removeAllObjects];
    [KWOriginalInitByClass removeAllObjects];
}

+ (id)anyInstance {
    Class allocatedClass = KWAllocatedClassByAnyInstanceReceiver[self];
    Class receiverClass = object_getClass([self class]);

    if (!allocatedClass && ![KWAttachedClasseses containsObject:receiverClass]) {
        [self swizzleInitForAnyInstanceAttachmentIfNecessary];
        [self swizzleAllocForAllocatedInstanceAttacmentIfNecessary];
        [KWAttachedClasseses addObject:receiverClass];
    }

    KWFutureInstanceAttacher *attacher = [[[KWFutureInstanceAttacher alloc] init] autorelease];
    attacher.instanceClass = receiverClass;
  
    NSMutableArray *attachers = KWFutureInstanceAttachersByClass[receiverClass];
    if (!attachers) {
        attachers = [NSMutableArray array];
        KWFutureInstanceAttachersByClass[(id)receiverClass] = attachers;
    }
    
    [attachers addObject:attacher];
    return attacher;
}

+ (void)swizzleInitForAnyInstanceAttachmentIfNecessary {
    Class receiverClass = [self class];
    if ([KWAttachedClasseses containsObject:object_getClass(receiverClass)])
        return;
    
    const SEL origSel = @selector(init);
    Method origMethod = class_getInstanceMethod(receiverClass, origSel);
    IMP originalIMP = method_getImplementation(origMethod);
    KWOriginalInitByClass[(id)receiverClass] = [NSValue valueWithPointer:originalIMP];
    
    IMP newImp = imp_implementationWithBlock(^(id _self){
        id instance = originalIMP(_self, origSel);
        [[_self class] kw_addVerifyingForAnyInstance:instance];
        return instance;
    });
    
    class_replaceMethod(receiverClass, origSel, newImp, method_getTypeEncoding(origMethod));
}

+ (void)swizzleAllocForAllocatedInstanceAttacmentIfNecessary {
    Class receiverClass = object_getClass([self class]);
    if ([KWAttachedClasseses containsObject:receiverClass])
        return;
    
    const SEL origSel = @selector(alloc);
    Method origMethod = class_getClassMethod(receiverClass, origSel);
    IMP originalIMP = method_getImplementation(origMethod);
    KWOriginalAllocByClass[(id)receiverClass] = [NSValue valueWithPointer:originalIMP];
    
    IMP newImp = imp_implementationWithBlock(^(id _self){
        id instance = originalIMP(_self, origSel);
        Class instanceClass = object_getClass(instance);
        if ((instanceClass != receiverClass) &&
            ([KWAttachedClasseses containsObject:receiverClass]
            && ![KWAttachedClasseses containsObject:instanceClass])) {
                KWAllocatedClassByAnyInstanceReceiver[(id)instanceClass] = receiverClass;
                [instanceClass swizzleInitForAnyInstanceAttachmentIfNecessary];
                [KWAttachedClasseses addObject:instanceClass];
        }
        
        return instance;
    });
    
    class_replaceMethod(receiverClass, origSel, newImp, method_getTypeEncoding(origMethod));
}

+ (void)kw_addVerifyingForAnyInstance:(id)anInstance {
    NSArray *attachers = KWFutureInstanceAttachersByClass[[self kw_attachedClasses]];
    [attachers makeObjectsPerformSelector:@selector(addInstance:) withObject:anInstance];
}

+ (Class)kw_attachedClasses {
    Class receiverClass = [self class];
    Class allocatedClass = KWAllocatedClassByAnyInstanceReceiver[receiverClass];
    Class attachedClass  = allocatedClass ? allocatedClass : receiverClass;
    return attachedClass;
}

@end
