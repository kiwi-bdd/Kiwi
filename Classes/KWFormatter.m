//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWFormatter.h"

@implementation KWFormatter


#pragma mark - Getting Descriptions

+ (NSString *)formatObject:(id)anObject {
    if ([anObject isKindOfClass:[NSString class]])
        return [NSString stringWithFormat:@"\"%@\"", anObject];

    else if ([anObject isKindOfClass:[NSDictionary class]])
        return [anObject description]; // NSDictionary conforms to NSFastEnumeration

    else if ([anObject conformsToProtocol:@protocol(NSFastEnumeration)])
        return [self formattedCollection:anObject];

    return [anObject description];
}



#pragma mark - Private

+ (NSString *)formattedCollection:(id<NSFastEnumeration>)collection {

    NSMutableString *description = [[[NSMutableString alloc] initWithString:@"("] autorelease];
    NSUInteger index = 0;
    
    for (id object in collection) {
        if (index == 0)
            [description appendFormat:@"%@", [self formatObject:object]];
        else
            [description appendFormat:@", %@", [self formatObject:object]];
        
        ++index;
    }
    
    [description appendString:@")"];
    return description;
}



@end
