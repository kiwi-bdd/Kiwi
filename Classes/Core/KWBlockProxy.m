//
//  KWBlockProxy.m
//  Kiwi
//
//  Created by Adam Sharp on 24/02/2014.
//  Copyright (c) 2014 Allen Ding. All rights reserved.
//

#import <objc/message.h>
#import "KWBlockProxy.h"

/**
 Based heavily on Mike Ash's code described in the post "Generic Block Proxying":
 https://www.mikeash.com/pyblog/friday-qa-2011-10-28-generic-block-proxying.html.
 */

struct BlockDescriptor {
    unsigned long reserved;
    unsigned long size;
    void *rest[1];
};

struct Block {
    void *isa;
    int flags;
    int reserved;
    void *invoke;
    struct BlockDescriptor *descriptor;
};

enum {
    BLOCK_HAS_COPY_DISPOSE =  (1 << 25),
    BLOCK_HAS_CTOR =          (1 << 26), // helpers have C++ code
    BLOCK_IS_GLOBAL =         (1 << 28),
    BLOCK_HAS_STRET =         (1 << 29), // IFF BLOCK_HAS_SIGNATURE
    BLOCK_HAS_SIGNATURE =     (1 << 30),
};

static void *BlockImpl(id block)
{
    return ((__bridge struct Block *)block)->invoke;
}

static const char *BlockSig(id blockObj)
{
    struct Block *block = (__bridge void *)blockObj;
    struct BlockDescriptor *descriptor = block->descriptor;

    assert(block->flags & BLOCK_HAS_SIGNATURE);

    int index = 0;
    if(block->flags & BLOCK_HAS_COPY_DISPOSE)
        index += 2;

    return descriptor->rest[index];
}

@interface NSInvocation (PrivateHack)
- (void)invokeUsingIMP:(IMP)imp;
@end

@interface KWBlockProxy ()
{
    int _flags;
    int _reserved;
    IMP _invoke;
    struct BlockDescriptor *_descriptor;

    id _forwardingBlock;
}
@end

@implementation KWBlockProxy

- (id)init {
    return [self initWithBlock:nil];
}

- (id)initWithBlock:(id)block {
    if ((self = [super init])) {

        if (!block)
            block = ^{};

        _forwardingBlock = [block copy];

        // NB: The bottom 16 bits represent the block's retain count
        _flags = ((__bridge struct Block *) block)->flags & ~0xFFFF;

        _descriptor = malloc(sizeof(struct BlockDescriptor));
        _descriptor->size = class_getInstanceSize([self class]);

        int index = 0;
        if (_flags & BLOCK_HAS_COPY_DISPOSE)
            index += 2;

        _descriptor->rest[index] = (void *)BlockSig(block);

        if (_flags & BLOCK_HAS_STRET)
            _invoke = (IMP) _objc_msgForward_stret;
        else
            _invoke = _objc_msgForward;
    }
    return self;
}

- (void)dealloc {
    free(_descriptor);
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    const char *types = BlockSig(_forwardingBlock);
    NSMethodSignature *sig = [NSMethodSignature signatureWithObjCTypes: types];
    while([sig numberOfArguments] < 2)
    {
        types = [[NSString stringWithFormat: @"%s%s", types, @encode(void *)] UTF8String];
        sig = [NSMethodSignature signatureWithObjCTypes: types];
    }
    return sig;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    KWBlockInvocationProxy proxy = self.invocationProxy;
    if (proxy) {
        [anInvocation setTarget:_forwardingBlock];
        proxy(anInvocation, ^{
            [anInvocation invokeUsingIMP:BlockImpl(_forwardingBlock)];
        });
    }
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

@end
