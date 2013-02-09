//
// Licensed under the terms in License.txt
//
// Copyright 2013 Stepan Hruda. All rights reserved.
//

#import "KWWeakPointer.h"

@implementation KWWeakPointer

#pragma mark - Public Interface

+ (KWWeakPointer *)weakPointerToObject:(id)object {
    KWWeakPointer *pointer = [KWWeakPointer new];
    pointer.object = object;
    return pointer;
}

#pragma mark - NSObject Overrides

- (BOOL)isEqual:(id)object {
    if (!self.object) {
        return NO;
    } else if (![object isKindOfClass:[KWWeakPointer class]]) {
        return NO;
    } else {
        KWWeakPointer *other = (KWWeakPointer *)object;
        if (!other.object) {
            return NO;
        } else {
            return self.object == other.object;
        }
    }
}

- (NSUInteger)hash {
    return [self.object hash];
}

#pragma mark - NSCopying Protocol Methods

- (id)copyWithZone:(NSZone *)zone {
    KWWeakPointer *copy = [KWWeakPointer new];
    copy.object = self.object;
    return copy;
}

@end
