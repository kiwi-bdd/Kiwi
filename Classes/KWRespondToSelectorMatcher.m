//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWRespondToSelectorMatcher.h"
#import "KWFormatter.h"

@interface KWRespondToSelectorMatcher()

#pragma mark -
#pragma mark Properties

@property (nonatomic, readwrite) SEL selector;

@end

@implementation KWRespondToSelectorMatcher

#pragma mark -
#pragma mark Properties

@synthesize selector;

#pragma mark -
#pragma mark Getting Matcher Strings

+ (NSArray *)matcherStrings {
    return @[@"respondToSelector:"];
}

#pragma mark -
#pragma mark Matching

- (BOOL)evaluate {
    return [self.subject respondsToSelector:self.selector];
}

#pragma mark -
#pragma mark Getting Failure Messages

- (NSString *)failureMessageForShould {
    return [NSString stringWithFormat:@"expected subject to respond to -%@",
                                      NSStringFromSelector(self.selector)];
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"respond to -%@", NSStringFromSelector(self.selector)];
}

#pragma mark -
#pragma mark Configuring Matchers

- (void)respondToSelector:(SEL)aSelector {
    self.selector = aSelector;
}

@end
