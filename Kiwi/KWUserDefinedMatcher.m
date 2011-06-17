//
//  KWUserDefinedMatcher.m
//  Kiwi
//
//  Created by Luke Redpath on 16/06/2011.
//  Copyright 2011 Allen Ding. All rights reserved.
//

#import "KWUserDefinedMatcher.h"

@implementation KWUserDefinedMatcher

@synthesize selector;

+ (id)matcherWithSubject:(id)subject block:(KWUserDefinedMatcherBlock)aBlock
{
    return [[[self alloc] initWithSubject:subject block:aBlock] autorelease];
}

- (id)initWithSubject:(id)subject block:(KWUserDefinedMatcherBlock)aBlock
{
    if ((self = [super initWithSubject:subject])) {
        matcherBlock = [aBlock copy];
    }
    return self;
}

- (void)dealloc
{
    [invocation release];
    [matcherBlock release];
    [super dealloc];
}

- (BOOL)evaluate
{
    BOOL result;
    
    if (invocation.methodSignature.numberOfArguments == 3) {
        id argument;
        [invocation getArgument:&argument atIndex:2];
        result = matcherBlock(self.subject, argument);
    } else {
        result = matcherBlock(self.subject);
    }
    return result;
}

#pragma mark -
#pragma mark Message forwarding

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if (aSelector == self.selector) {
        return YES;
    }
    return [super respondsToSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    [invocation autorelease];
    invocation = [anInvocation retain];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    if (aSelector == self.selector) {
        NSString *selectorString = NSStringFromSelector(self.selector);
        
        /**
         *   TODO: find a way of doing this that:
         *   - doesn't require dummy methods (create the method signatures manually)
         *   - supports an unlimited number of arguments
         */
        if ([selectorString hasSuffix:@":"]) {
            return [self methodSignatureForSelector:@selector(matcherMethodWithArgument:)];
        } else {
            return [self methodSignatureForSelector:@selector(matcherMethodWithoutArguments)];
        }
    }
    return [super methodSignatureForSelector:aSelector];
}

- (void)matcherMethodWithoutArguments {}
- (void)matcherMethodWithArgument:(id)argument {}

@end

#pragma mark -

@implementation KWUserDefinedMatcherBuilder

+ (id)builder 
{
    return [self builderForSelector:nil];
}

+ (id)builderForSelector:(SEL)aSelector {
    return [[[self alloc] initWithSelector:aSelector] autorelease];
}

- (id)initWithSelector:(SEL)aSelector {
    if ((self = [super init])) {
        selector = aSelector;
    }
    return self;
}

- (NSString *)key {
    return NSStringFromSelector(selector);
}

- (void)match:(KWUserDefinedMatcherBlock)block {
    Block_release(matcherBlock);
    matcherBlock = Block_copy(block);
}

- (KWUserDefinedMatcher *)buildMatcherWithSubject:(id)subject {
    return [KWUserDefinedMatcher matcherWithSubject:subject block:matcherBlock];
}

@end
