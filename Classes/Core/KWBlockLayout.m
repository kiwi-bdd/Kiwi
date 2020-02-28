//
//  KWBlockLayout.m
//  Kiwi
//
//  Created by Oleksa 'trimm' Korin on 4/16/16.
//  Copyright © 2016 Allen Ding. All rights reserved.
//

#import <objc/message.h>

#import "KWBlockLayout.h"
#import "KWBlockSignature.h"

kKWBlockOptions KWBlockLayoutGetFlags(KWBlockLayout *block) {
    // refcount is unneeded, as wel, as deallocating, so we filter them out from the flags
    return block->flags & ~(kKWBlockRefcountMask | kKWBlockDeallocating);
}

BOOL KWBlockLayoutGetOption(KWBlockLayout *block, kKWBlockOptions option) {
    return (KWBlockLayoutGetFlags(block) & option) > 0;
}

BOOL KWBlockLayoutHasCopyDispose(KWBlockLayout *block) {
    return KWBlockLayoutGetOption(block, kKWBlockHasCopyDispose);
}

BOOL KWBlockLayoutHasCTOR(KWBlockLayout *block) {
    return KWBlockLayoutGetOption(block, kKWBlockHasCTOR);
}

BOOL KWBlockLayoutIsGlobal(KWBlockLayout *block) {
    return KWBlockLayoutGetOption(block, kKWBlockIsGlobal);
}

BOOL KWBlockLayoutHasStructureReturn(KWBlockLayout *block) {
    // block only has structure return, when it has signature
    return KWBlockLayoutGetOption(block, kKWBlockHasStructureReturn) && KWBlockLayoutHasSignature(block);
}

BOOL KWBlockLayoutHasSignature(KWBlockLayout *block) {
    return KWBlockLayoutGetOption(block, kKWBlockHasSignature);
}

BOOL KWBlockLayoutHasExtendedLayout(KWBlockLayout *block) {
    return KWBlockLayoutGetOption(block, kKWBlockHasExtendedLayout);
}

IMP KWBlockLayoutGetImp(KWBlockLayout *block) {
    return block->imp;
}

uintptr_t KWBlockLayoutGetDescriptorSize(KWBlockLayout *block) {
    return KWBlockLayoutGetDescriptor(block)->size;
}

const char *KWBlockLayoutGetSignature(KWBlockLayout *block) {
    if (!KWBlockLayoutHasSignature(block)) {
        return NULL;
    }
    
    return KWBlockLayoutGetDescriptorMetadata(block)->signature;
}

NSMethodSignature *KWBlockLayoutGetMethodSignature(KWBlockLayout *block) {
    // if there is no signature, we consider block to be returning void
    const char *UTF8Signature = KWBlockLayoutHasSignature(block) ? KWBlockLayoutGetSignature(block) : @encode(void);
    
    NSString *signature = [NSString stringWithFormat: @"%s", UTF8Signature];
    NSMethodSignature *result = [KWBlockSignature signatureWithObjCTypes:signature.UTF8String];
    
    // If there are not enough arguments, we append them by adding void *, which is valid for both id and SEL
    // Forwarding expects the ObjC signature return(self, _cmd)
    if (result.numberOfArguments < 1) {
        signature = [NSString stringWithFormat:@"%@%s", signature, @encode(void *)];
        result = [NSMethodSignature signatureWithObjCTypes:signature.UTF8String];
    }
    
    return result;
}

KWBlockDescriptor *KWBlockLayoutGetDescriptor(KWBlockLayout *block) {
    return block->descriptor;
}

KWBlockDescriptorMetadata *KWBlockLayoutGetDescriptorMetadata(KWBlockLayout *block) {
    // signature is only available, if the appropriate flag is set
    if (!KWBlockLayoutHasSignature(block)) {
        return NULL;
    }

    // _Block_descriptor_3: http://opensource.apple.com//source/libclosure/libclosure-65/runtime.c
    // It's layed out from descriptor pointer inside KWBlockLayout in the following way:
    // - KWBlockDescriptor
    // - KWBlockDescriptorCopyDispose - if kKWBlockHasCopyDispose flag is set, otherwise it's not there
    // - KWBlockDescriptorMetadata
    uint8_t *address = (uint8_t *)KWBlockLayoutGetDescriptor(block);
    address += sizeof(KWBlockDescriptor);
    if (KWBlockLayoutHasCopyDispose(block)) {
        address += sizeof(KWBlockDescriptorCopyDispose);
    }
    
    return (KWBlockDescriptorMetadata *)address;
}

IMP KWBlockLayoutGetForwardingImp(KWBlockLayout *block) {
    // explicit type casting for OBJC_OLD_DISPATCH_PROTOTYPES
    return (IMP)(KWBlockLayoutHasStructureReturn(block) ? _objc_msgForward_stret : _objc_msgForward);
}
