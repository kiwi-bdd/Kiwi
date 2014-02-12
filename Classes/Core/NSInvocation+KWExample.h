//
//  NSInvocation+KWExampleSuite.h
//  Kiwi
//
//  Created by Brian Ivan Gesiak on 2/12/14.
//  Copyright (c) 2014 Allen Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KWExample;

@interface NSInvocation (KWExample)
- (void)kw_setExample:(KWExample *)example;
- (KWExample *)kw_example;
- (void)kw_setIsFirstExample:(BOOL)isFirstExample;
- (BOOL)kw_isFirstExample;
- (void)kw_setIsLastExample:(BOOL)isLastExample;
- (BOOL)kw_isLastExample;
@end
