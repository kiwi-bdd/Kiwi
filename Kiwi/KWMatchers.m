//
//  KWMatchers.m
//  Kiwi
//
//  Created by Luke Redpath on 17/06/2011.
//  Copyright 2011 Allen Ding. All rights reserved.
//

#import "KWMatchers.h"
#import "KWUserDefinedMatcher.h"

@implementation KWMatchers

#pragma mark -
#pragma mark Singleton implementation

static id sharedMatchers = nil;

+ (void)initialize {
  if (self == [KWMatchers class]) {
    sharedMatchers = [[self alloc] init];
  }
}

+ (id)matchers {
  return sharedMatchers;
}

- (id)init {
    if ((self = [super init])) {
        userDefinedMatchers = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark -
#pragma mark Defining Matchers

+ (void)defineMatcher:(NSString *)selectorString as:(KWMatchersBuildingBlock)block {
    [[self matchers] defineMatcher:selectorString as:block];
}

- (void)defineMatcher:(NSString *)selectorString as:(KWMatchersBuildingBlock)block {
    KWUserDefinedMatcherBuilder *builder = [KWUserDefinedMatcherBuilder builderForSelector:NSSelectorFromString(selectorString)];
    block(builder);
    [userDefinedMatchers setObject:builder forKey:builder.key];
}

- (void)addUserDefinedMatcherBuilder:(KWUserDefinedMatcherBuilder *)builder {
    [userDefinedMatchers setObject:builder forKey:builder.key];
}

#pragma mark -
#pragma mark Building Matchers

- (KWUserDefinedMatcher *)matcherForSelector:(SEL)selector subject:(id)subject {
    KWUserDefinedMatcherBuilder *builder = [userDefinedMatchers objectForKey:NSStringFromSelector(selector)];

    if (builder == nil)
        return nil;

    return [builder buildMatcherWithSubject:subject];
}


@end

void KWDefineMatchers(NSString *selectorString, KWMatchersBuildingBlock block)
{
    [KWMatchers defineMatcher:selectorString as:block];
}

