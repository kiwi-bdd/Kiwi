//
//  KWUserDefinedMatcher.m
//  Kiwi
//
//  Created by Luke Redpath on 16/06/2011.
//  Copyright 2011 Allen Ding. All rights reserved.
//

#import "KWUserDefinedMatcher.h"

@interface KWUserDefinedMatcher(){}
@property (nonatomic, copy) NSInvocation *invocation;
@end

@implementation KWUserDefinedMatcher

@synthesize selector;
@synthesize failureMessageForShould;
@synthesize failureMessageForShouldNot;
@synthesize matcherBlock;
@synthesize description;

+ (id)matcherWithSubject:(id)aSubject block:(KWUserDefinedMatcherBlock)aBlock {
    return [[self alloc] initWithSubject:aSubject block:aBlock];
}

- (id)initWithSubject:(id)aSubject block:(KWUserDefinedMatcherBlock)aBlock {
    self = [super initWithSubject:aSubject];
    if (self) {
        matcherBlock = [aBlock copy];
        self.description = @"match user defined matcher";
    }
    return self;
}


- (BOOL)evaluate {
    BOOL result;

    if (self.invocation.methodSignature.numberOfArguments == 3) {
        id argument;
        [self.invocation getArgument:&argument atIndex:2];
        result = matcherBlock(self.subject, argument);
    } else {
        result = matcherBlock(self.subject);
    }
    return result;
}

#pragma mark - Message forwarding

- (BOOL)respondsToSelector:(SEL)aSelector {
    if (aSelector == self.selector) {
        return YES;
    }
    return [super respondsToSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    _invocation = anInvocation;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
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

@interface KWUserDefinedMatcherBuilder ()

@property (nonatomic, strong) KWUserDefinedMatcher *matcher;
@property (nonatomic, copy) KWUserDefinedMatcherMessageBlock failureMessageForShouldBlock;
@property (nonatomic, copy) KWUserDefinedMatcherMessageBlock failureMessageForShouldNotBlock;
@property (nonatomic, copy) NSString *matcherBuilderDescription;

@end

@implementation KWUserDefinedMatcherBuilder

+ (id)builder {
    return [self builderForSelector:nil];
}

+ (id)builderForSelector:(SEL)aSelector {
    return [[self alloc] initWithSelector:aSelector];
}

- (id)initWithSelector:(SEL)aSelector {
    self = [super init];
    if (self) {
        _matcher = [[KWUserDefinedMatcher alloc] init];
        _matcher.selector = aSelector;
    }
    return self;
}

- (NSString *)key {
    return NSStringFromSelector(self.matcher.selector);
}

#pragma mark - Configuring The Matcher

- (void)match:(KWUserDefinedMatcherBlock)block {
    self.matcher.matcherBlock = block;
}

- (void)failureMessageForShould:(KWUserDefinedMatcherMessageBlock)block {
    self.failureMessageForShouldBlock = block;
}

- (void)failureMessageForShouldNot:(KWUserDefinedMatcherMessageBlock)block {
    self.failureMessageForShouldNotBlock = block;
}

- (void)description:(NSString *)aDescription {
    self.matcherBuilderDescription = aDescription;
}

#pragma mark - Buiding The Matcher

- (KWUserDefinedMatcher *)buildMatcherWithSubject:(id)subject {
    [self.matcher setSubject:subject];

    if (self.failureMessageForShouldBlock) {
        [self.matcher setFailureMessageForShould:self.failureMessageForShouldBlock(subject)];
    }

    if (self.failureMessageForShouldNotBlock) {
        [self.matcher setFailureMessageForShouldNot:self.failureMessageForShouldNotBlock(subject)];
    }

    if (self.matcherBuilderDescription) {
        [self.matcher setDescription:self.matcherBuilderDescription];
    }

    return self.matcher;
}

@end
