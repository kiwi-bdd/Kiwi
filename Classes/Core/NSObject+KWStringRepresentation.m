//
// Licensed under the terms in License.txt
//
// Copyright 2014 Allen Ding. All rights reserved.
//

#import "NSObject+KWStringRepresentation.h"

@implementation NSObject (KWStringRepresentation)

- (NSString *)kw_stringRepresentation {
    if ([self isKindOfClass:[NSString class]]) {
        return [NSString stringWithFormat:@"\"%@\"", self];
    } else if ([self isKindOfClass:[NSDictionary class]]) {
        return [self description]; // NSDictionary conforms to NSFastEnumeration
    } else if ([self conformsToProtocol:@protocol(NSFastEnumeration)]) {
        return [self kw_collectionStringRepresentation];
    }

    return [self description];
}

- (NSString *)kw_stringRepresentationWithClass {
    NSString *classString = [[self class] description];

    if ([self isKindOfClass:[NSString class]]) {
        classString = @"NSString";
    }

    return [NSString stringWithFormat:@"(%@) %@", classString, [self kw_stringRepresentation]];
}

#pragma mark - Internal Methods

- (NSString *)kw_collectionStringRepresentation {
    NSMutableString *description = [[NSMutableString alloc] initWithString:@"("];
    NSUInteger index = 0;

    for (id object in (id<NSFastEnumeration>)self) {
        if (index == 0) {
            [description appendFormat:@"%@", [object kw_stringRepresentation]];
        } else {
            [description appendFormat:@", %@", [object kw_stringRepresentation]];
        }

        ++index;
    }

    [description appendString:@")"];
    return description;
}

@end
