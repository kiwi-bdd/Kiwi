//
//  KWProxyBlock.m
//  Kiwi
//
//  Created by Oleksa 'trimm' Korin on 4/18/16.
//  Copyright © 2016 Allen Ding. All rights reserved.
//

#import "KWProxyBlock.h"

#import "KWBlockLayout.h"
#import "KWBlockMessagePattern.h"
#import "KWMessageSpying.h"

#import "NSObject+KiwiStubAdditions.h"
#import "NSInvocation+KiwiAdditions.h"

@interface NSInvocation (KWPrivateInterface)

- (void)invokeUsingIMP:(IMP)imp;

@end

@interface KWProxyBlock()

#pragma mark - Properties

@property (nonatomic, readonly, copy) id block;
@property (nonatomic, readonly, assign) KWBlockLayout *blockLayout;
@property (nonatomic, readonly, assign) KWBlockDescriptor *descriptor;

@property (nonatomic, readonly) NSMutableSet *expectedMessagePatterns;
@property (nonatomic, readonly) NSMapTable *messageSpies;

#pragma mark - Methods

- (void)interposeBlock:(id)block;

@end

@implementation KWProxyBlock {
    // we imitate the block layout for block forwarding to work
    // the order of ivars is important
    volatile int32_t _flags;
    int32_t _reserved;
    IMP _imp;
    KWBlockDescriptor *_descriptor;
    
    // ivars related to our class, rather, than to the interposed block
    id _block;
}

@synthesize block = _block;
@synthesize descriptor = _descriptor;

@dynamic blockLayout;
@dynamic methodSignature;

#pragma mark - Deallocating

- (void)dealloc {
    free(_descriptor);
    _descriptor = NULL;
}

#pragma mark - Initializing

- (id)initWithBlock:(id)block {
    self = [super init];
    if (self) {
        _expectedMessagePatterns = [NSMutableSet new];
        _messageSpies = [NSMapTable mapTableWithKeyOptions:NSMapTableStrongMemory valueOptions:NSMapTableStrongMemory];
        
        _block = [block copy];
        [self interposeBlock:_block];
    }
    
    return self;
}

+ (id)blockWithBlock:(id)aBlock {
    return [[self alloc] initWithBlock:aBlock];
}

#pragma mark - Block Interposing

- (void)interposeBlock:(id)interposeBlock {
    KWBlockLayout *block = (__bridge KWBlockLayout *)interposeBlock;
    
    _flags = KWBlockLayoutGetFlags(block);
    
    if (_descriptor) {
        free(_descriptor);
    }
    
    uintptr_t interposeSize = KWBlockLayoutGetDescriptorSize(block);
    _descriptor = calloc(1, interposeSize);
    
    KWBlockDescriptor *descriptor = KWBlockLayoutGetDescriptor(block);
    memcpy(_descriptor, descriptor, interposeSize);
    
    _imp = KWBlockLayoutGetForwardingImp(block);
}

- (id)copyWithZone:(nullable NSZone *)zone {
    return self;
}

#pragma mark - Properties

- (KWBlockLayout *)blockLayout {
    return (__bridge KWBlockLayout *)(self.block);
}

- (NSMethodSignature *)methodSignature {
    return KWBlockLayoutGetMethodSignature(self.blockLayout);
}

#pragma mark - Forwarding

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return self.methodSignature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    [anInvocation becomeBlockInvocation];
    
    NSMapTable *spiesMap = self.messageSpies;
    for (KWBlockMessagePattern *messagePattern in spiesMap) {
        if ([messagePattern matchesInvocation:anInvocation]) {
            NSArray *spies = [spiesMap objectForKey:messagePattern];
            
            for (id<KWMessageSpying> spy in spies) {
                [spy object:self didReceiveInvocation:anInvocation];
            }
        }
    }
    
    [anInvocation setTarget:self.block];
    [anInvocation invokeUsingIMP:KWBlockLayoutGetImp(self.blockLayout)];
}

- (void)addMessageSpy:(id<KWMessageSpying>)aSpy forMessagePattern:(KWMessagePattern *)aMessagePattern {
    if (![aMessagePattern isKindOfClass:[KWBlockMessagePattern class]]) {
        [super addMessageSpy:aSpy forMessagePattern:aMessagePattern];
    }
    
    [self.expectedMessagePatterns addObject:aMessagePattern];
    NSMutableArray *messagePatternSpies = [self.messageSpies objectForKey:aMessagePattern];
    
    if (messagePatternSpies == nil) {
        messagePatternSpies = [[NSMutableArray alloc] init];
        [self.messageSpies setObject:messagePatternSpies forKey:aMessagePattern];
    }
    
    if (![messagePatternSpies containsObject:aSpy])
        [messagePatternSpies addObject:aSpy];
}

- (void)removeMessageSpy:(id<KWMessageSpying>)aSpy forMessagePattern:(KWMessagePattern *)aMessagePattern {
    if (![aMessagePattern isKindOfClass:[KWBlockMessagePattern class]]) {
        [super removeMessageSpy:aSpy forMessagePattern:aMessagePattern];
    }
    
    NSMutableArray *messagePatternSpies = [self.messageSpies objectForKey:aMessagePattern];
    [messagePatternSpies removeObject:aSpy];
}

@end

KWProxyBlock *theBlockProxy(id block) {
    return [KWProxyBlock blockWithBlock:block];
}

KWProxyBlock *lambdaProxy(id block) {
    return theBlockProxy(block);
}
