//
//  NSObject+KiwiAdditions.h
//  Kiwi
//
//  Created by Luke Redpath on 24/01/2011.
//  Copyright 2011 Allen Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (KiwiHamcrestAdditions)

- (BOOL)isEqualOrMatches:(id)object;

@end

@protocol HCMatcher;

@interface NSArray (KiwiHamcrestAdditions)

- (BOOL)containsObjectEqualToOrMatching:(id)object;
- (BOOL)containsObjectMatching:(id<HCMatcher>)matcher;

@end

