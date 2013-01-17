//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"
#import "KWCountType.h"
#import "KWMatcher.h"
#import "KWMatchVerifier.h"

@interface KWHaveMatcher : KWMatcher {
@private
    KWCountType countType;
    NSUInteger count;
    NSInvocation *invocation;
    NSUInteger actualCount;
}

#pragma mark -
#pragma mark Configuring Matchers

- (void)haveCountOf:(NSUInteger)aCount;
- (void)haveCountOfAtLeast:(NSUInteger)aCount;
- (void)haveCountOfAtMost:(NSUInteger)aCount;
- (void)have:(NSUInteger)aCount itemsForInvocation:(NSInvocation *)anInvocation;
- (void)haveAtLeast:(NSUInteger)aCount itemsForInvocation:(NSInvocation *)anInvocation;
- (void)haveAtMost:(NSUInteger)aCount itemsForInvocation:(NSInvocation *)anInvocation;

@end

@protocol KWContainmentCountMatcherTerminals

#pragma mark -
#pragma mark Terminals

- (id)objects;
- (id)items;
- (id)elements;

@end

@interface KWMatchVerifier(KWHaveMatcherAdditions)

#pragma mark -
#pragma mark Verifying

#pragma mark Invocation Capturing Methods

- (id)have:(NSUInteger)aCount;
- (id)haveAtLeast:(NSUInteger)aCount;
- (id)haveAtMost:(NSUInteger)aCount;

@end
