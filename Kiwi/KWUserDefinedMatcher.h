//
//  KWUserDefinedMatcher.h
//  Kiwi
//
//  Created by Luke Redpath on 16/06/2011.
//  Copyright 2011 Allen Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KWMatcher.h"

typedef BOOL (^KWUserDefinedMatcherBlock)();

@interface KWUserDefinedMatcher : KWMatcher
{
    KWUserDefinedMatcherBlock matcherBlock;
    SEL selector;
    NSInvocation *invocation;
}
@property (nonatomic, assign) SEL selector;

+ (id)matcherWithSubject:(id)subject block:(KWUserDefinedMatcherBlock)aBlock;
- (id)initWithSubject:(id)subject block:(KWUserDefinedMatcherBlock)aBlock;
@end

#pragma mark -

@interface KWUserDefinedMatcherBuilder : NSObject 
{
  KWUserDefinedMatcherBlock matcherBlock;
  SEL selector;
}
@property (nonatomic, readonly) NSString *key;

+ (id)builder;
+ (id)builderForSelector:(SEL)aSelector;
- (id)initWithSelector:(SEL)aSelector;
- (void)match:(KWUserDefinedMatcherBlock)block;
- (KWUserDefinedMatcher *)buildMatcherWithSubject:(id)subject;
@end