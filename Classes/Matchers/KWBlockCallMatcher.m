//
//  KWBlockCallMatcher.m
//  Kiwi
//
//  Created by Adam Sharp on 24/02/2014.
//  Copyright (c) 2014 Allen Ding. All rights reserved.
//

#import "KWBlockCallMatcher.h"
#import "KWBlockProxy.h"

@interface KWBlockCallMatcher ()
@property (nonatomic) BOOL called;
@end

@implementation KWBlockCallMatcher

+ (NSArray *)matcherStrings {
    return @[@"beCalled"];
}

- (BOOL)shouldBeEvaluatedAtEndOfExample {
    return YES;
}

- (void)beCalled {
    NSAssert([self.subject isKindOfClass:[KWBlockProxy class]], @"expected subject to be a block proxy");

    KWBlockProxy *proxy = self.subject;
    proxy.invocationProxy = ^(NSInvocation *inv, void (^call)(void)) {
        self.called = YES;
    };
}

- (BOOL)evaluate {
    return [self called];
}

- (NSString *)failureMessageForShould {
    return @"expected block to be called";
}

- (NSString *)failureMessageForShouldNot {
    return @"expected block not to be called";
}

@end
