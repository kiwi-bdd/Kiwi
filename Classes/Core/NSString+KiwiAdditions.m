//
//  NSString+KiwiAdditions.m
//  Kiwi
//
//  Created by Cristian Kocza on 02/04/14.
//  Copyright (c) 2014 Allen Ding. All rights reserved.
//

#import "NSString+KiwiAdditions.h"

@implementation NSString (KiwiAdditions)

// Per http://clang.llvm.org/docs/AutomaticReferenceCounting.html#method-families
// A selector is in a certain selector family if, ignoring any leading underscores, the first component
// of the selector either consists entirely of the name of the method family or it begins with that name
// followed by a character other than a lowercase letter. For example, _perform:with: and performWith:
// would fall into the perform family (if we recognized one), but performing:with would not.
- (BOOL)belongsToMethodFamily:(NSString*)family{
    NSUInteger pos = 0;
    NSUInteger selfLen = self.length;
    NSUInteger familyLen = family.length;
    while([self characterAtIndex:pos] == '_' && pos < selfLen) pos++;
    if(selfLen >= pos+familyLen && [[self substringWithRange:NSMakeRange(pos, familyLen)] isEqualToString:family]){
        pos += familyLen;
        if(pos == selfLen) return YES;
        unichar c = [self characterAtIndex:pos];
        return c < 'a' || c > 'z';
    }else{
        return NO;
    }
}

@end
