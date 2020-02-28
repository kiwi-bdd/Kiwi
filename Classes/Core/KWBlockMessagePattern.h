//
//  KWMessagePattern.h
//  Kiwi
//
//  Created by Oleksa 'trimm' Korin on 4/19/16.
//  Copyright © 2016 Allen Ding. All rights reserved.
//

#import "KWMessagePattern.h"

@interface KWBlockMessagePattern : KWMessagePattern

#pragma mark - Initializing

- (id)initWithSignature:(NSMethodSignature *)signature;
- (id)initWithSignature:(NSMethodSignature *)signature argumentFilters:(NSArray *)anArray;
- (id)initWithSignature:(NSMethodSignature *)signature
    firstArgumentFilter:(id)firstArgumentFilter
           argumentList:(va_list)argumentList;

+ (id)messagePatternWithSignature:(NSMethodSignature *)signature;
+ (id)messagePatternWithSignature:(NSMethodSignature *)signature argumentFilters:(NSArray *)anArray;
+ (id)messagePatternWithSignature:(NSMethodSignature *)signature
              firstArgumentFilter:(id)firstArgumentFilter
                     argumentList:(va_list)argumentList;

#pragma mark - Properties

@property (nonatomic, readonly) NSMethodSignature   *signature;

@end
