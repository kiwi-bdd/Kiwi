//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWMessagePattern.h"

@interface KWSelectorMessagePattern : KWMessagePattern

#pragma mark - Initializing

- (id)initWithSelector:(SEL)aSelector;
- (id)initWithSelector:(SEL)aSelector argumentFilters:(NSArray *)anArray;
- (id)initWithSelector:(SEL)aSelector firstArgumentFilter:(id)firstArgumentFilter argumentList:(va_list)argumentList;

+ (id)messagePatternWithSelector:(SEL)aSelector;
+ (id)messagePatternWithSelector:(SEL)aSelector argumentFilters:(NSArray *)anArray;
+ (id)messagePatternWithSelector:(SEL)aSelector firstArgumentFilter:(id)firstArgumentFilter argumentList:(va_list)argumentList;

#pragma mark - Properties

@property (nonatomic, readonly) SEL selector;

@end
