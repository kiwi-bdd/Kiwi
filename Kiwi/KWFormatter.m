//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWFormatter.h"

@implementation KWFormatter

#pragma mark -
#pragma mark Getting Descriptions

+ (NSString *)formatObject:(id)anObject {
    if ([anObject isKindOfClass:[NSString class]])
        return [NSString stringWithFormat:@"\"%@\"", anObject];
    
    if ([anObject conformsToProtocol:@protocol(NSFastEnumeration)]) {
        NSMutableString *description = [[[NSMutableString alloc] initWithString:@"("] autorelease];
        NSUInteger index = 0;
        
        for (id object in anObject) {
            if (index == 0)
                [description appendFormat:@"%@", [self formatObject:object]];
            else
                [description appendFormat:@", %@", [self formatObject:object]];
            
            ++index;
        }
        
        [description appendString:@")"];
        return description;
    }
    
    return [anObject description];
}

@end
