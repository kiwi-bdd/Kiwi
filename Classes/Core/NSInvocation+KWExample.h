//
// Licensed under the terms in License.txt
//
// Copyright 2014 Allen Ding. All rights reserved.
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
