//
//  KWAbstractMessagePattern.h
//  Kiwi
//
//  Created by Oleksa 'trimm' Korin on 4/26/16.
//  Copyright © 2016 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"

@interface KWMessagePattern : NSObject

#pragma mark - Initializing

+ (id)messagePatternFromInvocation:(NSInvocation *)anInvocation;

// this method should be overloaded by subclasses
- (id)initWithInvocation:(NSInvocation *)anInvocation;

#pragma mark - Properties

@property (nonatomic, readonly) NSArray *argumentFilters;

#pragma mark - Matching Invocations

- (BOOL)matchesInvocation:(NSInvocation *)anInvocation;

#pragma mark - Comparing Message Patterns

- (BOOL)isEqualToMessagePattern:(id)aMessagePattern;

#pragma mark - Retrieving String Representations

// this method should be overloaded by subclasses
- (NSString *)stringValue;

@end

// cluster methods for KWSelectorMessagePattern
@interface KWMessagePattern (KWSelectorMessagePatternCluster)

#pragma mark - Initializing

- (id)initWithSelector:(SEL)aSelector NS_REPLACES_RECEIVER;
- (id)initWithSelector:(SEL)aSelector argumentFilters:(NSArray *)anArray NS_REPLACES_RECEIVER;
- (id)initWithSelector:(SEL)aSelector
   firstArgumentFilter:(id)firstArgumentFilter
          argumentList:(va_list)argumentList NS_REPLACES_RECEIVER;

+ (id)messagePatternWithSelector:(SEL)aSelector;
+ (id)messagePatternWithSelector:(SEL)aSelector argumentFilters:(NSArray *)anArray;
+ (id)messagePatternWithSelector:(SEL)aSelector firstArgumentFilter:(id)firstArgumentFilter argumentList:(va_list)argumentList;

@end

// cluster methods for KWBlockMessagePattern
@interface KWMessagePattern (KWBlockMessagePatternCluster)

#pragma mark - Initializing

- (id)initWithSignature:(NSMethodSignature *)signature NS_REPLACES_RECEIVER;
- (id)initWithSignature:(NSMethodSignature *)signature argumentFilters:(NSArray *)anArray NS_REPLACES_RECEIVER;
- (id)initWithSignature:(NSMethodSignature *)signature
    firstArgumentFilter:(id)firstArgumentFilter
           argumentList:(va_list)argumentList NS_REPLACES_RECEIVER;

+ (id)messagePatternWithSignature:(NSMethodSignature *)signature;
+ (id)messagePatternWithSignature:(NSMethodSignature *)signature argumentFilters:(NSArray *)anArray;
+ (id)messagePatternWithSignature:(NSMethodSignature *)signature
              firstArgumentFilter:(id)firstArgumentFilter
                     argumentList:(va_list)argumentList;

@end

// methods in this category are used for inheritance and should not be called directly
@interface KWMessagePattern (KWMessagePatternPrivate)

#pragma mark - Initializing

- (id)initWithArgumentFilters:(NSArray *)anArray;

#pragma mark - Argument Filters Creation

- (NSArray *)argumentFiltersWithInvocation:(NSInvocation *)invocation;
- (NSArray *)argumentFiltersWithFirstArgumentFilter:(id)firstArgumentFilter
                                       argumentList:(va_list)argumentList
                                      argumentCount:(NSUInteger)count;

#pragma mark - Invocation Handling

// this method should be overloaded by subclasses
- (NSUInteger)argumentCountWithInvocation:(NSInvocation *)invocation;

@end

