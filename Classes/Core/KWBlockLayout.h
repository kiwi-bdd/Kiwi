//
//  KWBlockLibClosure.h
//  Kiwi
//
//  Created by Oleksa 'trimm' Korin on 4/16/16.
//  Copyright © 2016 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"

// Block types and helper methods derived from
// http://opensource.apple.com//source/libclosure/libclosure-65/Block_private.h
// http://opensource.apple.com//source/libclosure/libclosure-65/runtime.c

typedef enum {
    kKWBlockDeallocating        = (0x0001),  // runtime
    kKWBlockRefcountMask        = (0xfffe),  // runtime
    kKWBlockNeedsFree           = (1 << 24), // runtime
    kKWBlockHasCopyDispose      = (1 << 25), // compiler
    kKWBlockHasCTOR             = (1 << 26), // compiler: helpers have C++ code
    kKWBlockIsGC                = (1 << 27), // runtime
    kKWBlockIsGlobal            = (1 << 28), // compiler
    kKWBlockHasStructureReturn  = (1 << 29), // compiler: undefined if !kKWBlockHasSignature
    kKWBlockHasSignature        = (1 << 30), // compiler
    kKWBlockHasExtendedLayout   = (1 << 31)  // compiler
} kKWBlockOptions;

struct KWBlockDescriptor {
    uintptr_t reserved;
    uintptr_t size;
};
typedef struct KWBlockDescriptor KWBlockDescriptor;

struct KWBlockDescriptorCopyDispose {
    // requires kKWBlockHasCopyDispose
    void (*copy)(void *dst, const void *src);
    void (*dispose)(const void *);
};
typedef struct KWBlockDescriptorCopyDispose KWBlockDescriptorCopyDispose;

struct KWBlockDescriptorMetadata {
    // requires kKWBlockHasSignature
    const char *signature;
    const char *layout;     // contents depend on kKWBlockHasExtendedLayout
};
typedef struct KWBlockDescriptorMetadata KWBlockDescriptorMetadata;

struct KWBlockLayout {
    void *isa;
    volatile int32_t flags; // contains ref count
    int32_t reserved;
    IMP imp;
    KWBlockDescriptor *descriptor;
};
typedef struct KWBlockLayout KWBlockLayout;

FOUNDATION_EXPORT
kKWBlockOptions KWBlockLayoutGetFlags(KWBlockLayout *block);

FOUNDATION_EXPORT
BOOL KWBlockLayoutGetOption(KWBlockLayout *block, kKWBlockOptions option);

FOUNDATION_EXPORT
BOOL KWBlockLayoutHasCopyDispose(KWBlockLayout *block);

FOUNDATION_EXPORT
BOOL KWBlockLayoutHasCTOR(KWBlockLayout *block);

FOUNDATION_EXPORT
BOOL KWBlockLayoutIsGlobal(KWBlockLayout *block);

FOUNDATION_EXPORT
BOOL KWBlockLayoutHasStructureReturn(KWBlockLayout *block);

FOUNDATION_EXPORT
BOOL KWBlockLayoutHasSignature(KWBlockLayout *block);

FOUNDATION_EXPORT
BOOL KWBlockLayoutHasExtendedLayout(KWBlockLayout *block);

FOUNDATION_EXPORT
IMP KWBlockLayoutGetImp(KWBlockLayout *block);

FOUNDATION_EXPORT
uintptr_t KWBlockLayoutGetDescriptorSize(KWBlockLayout *block);

FOUNDATION_EXPORT
const char *KWBlockLayoutGetSignature(KWBlockLayout *block);

FOUNDATION_EXPORT
NSMethodSignature *KWBlockLayoutGetMethodSignature(KWBlockLayout *block);

FOUNDATION_EXPORT
KWBlockDescriptor *KWBlockLayoutGetDescriptor(KWBlockLayout *block);

FOUNDATION_EXPORT
KWBlockDescriptorMetadata *KWBlockLayoutGetDescriptorMetadata(KWBlockLayout *block);

FOUNDATION_EXPORT
IMP KWBlockLayoutGetForwardingImp(KWBlockLayout *block);
