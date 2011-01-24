//
//  NSObject+KiwiAdditions.m
//  Kiwi
//
//  Created by Luke Redpath on 24/01/2011.
//  Copyright 2011 Allen Ding. All rights reserved.
//

#import "KWHamrestMatchingAdditions.h"
#import "KWHCMatcher.h"

@implementation NSObject (KiwiHamcrestAdditions)

- (BOOL)isEqualOrMatches:(id)object
{
    if ([self conformsToProtocol:@protocol(HCMatcher)]) {
        return [(id<HCMatcher>)self matches:object];
    }
    return [self isEqual:object];
}

@end

@implementation NSArray (KiwiHamcrestAdditions)

- (BOOL)containsObjectEqualToOrMatching:(id)object
{
    if ([object conformsToProtocol:@protocol(HCMatcher)]) {
        return [self containsObjectMatching:object];
    }
    return [self containsObject:object];
}

- (BOOL)containsObjectMatching:(id<HCMatcher>)matcher
{
    NSIndexSet *indexSet = [self indexesOfObjectsPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
        BOOL matches = [matcher matches:obj];
        if (matches) {
          *stop = YES;
        }
        return matches;
    }];
    
    return (indexSet.count > 0);  
}

@end


