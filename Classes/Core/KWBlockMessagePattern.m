//
//  KWBlockMessagePattern.m
//  Kiwi
//
//  Created by Oleksa 'trimm' Korin on 4/19/16.
//  Copyright © 2016 Allen Ding. All rights reserved.
//

#import "KWBlockMessagePattern.h"

#import "KWFormatter.h"
#import "NSMethodSignature+KiwiAdditions.h"

@implementation KWBlockMessagePattern

#pragma mark - Initializing

- (id)initWithSignature:(NSMethodSignature *)signature {
    return [self initWithSignature:signature argumentFilters:nil];
}

- (id)initWithSignature:(NSMethodSignature *)signature argumentFilters:(NSArray *)anArray {
    self = [super initWithArgumentFilters:anArray];
    if (self) {
        _signature = signature;
    }
    
    return self;
}

- (id)initWithSignature:(NSMethodSignature *)signature
    firstArgumentFilter:(id)firstArgumentFilter
           argumentList:(va_list)argumentList
{
    NSUInteger argumentCount = [signature numberOfMessageArguments];
    NSArray *argumentFilters = [self argumentFiltersWithFirstArgumentFilter:firstArgumentFilter
                                                               argumentList:argumentList
                                                              argumentCount:argumentCount];
    
    return [self initWithSignature:signature argumentFilters:argumentFilters];
}

- (id)initWithInvocation:(NSInvocation *)anInvocation {
    NSArray *argumentFilters = [self argumentFiltersWithInvocation:anInvocation];
    
    return [self initWithSignature:anInvocation.methodSignature argumentFilters:argumentFilters];
}

+ (id)messagePatternWithSignature:(NSMethodSignature *)signature {
    return [[self alloc] initWithSignature:signature];
}

+ (id)messagePatternWithSignature:(NSMethodSignature *)signature argumentFilters:(NSArray *)anArray {
    return [[self alloc] initWithSignature:signature argumentFilters:anArray];
}

+ (id)messagePatternWithSignature:(NSMethodSignature *)signature
              firstArgumentFilter:(id)firstArgumentFilter
                     argumentList:(va_list)argumentList
{
    return [[self alloc] initWithSignature:signature firstArgumentFilter:firstArgumentFilter argumentList:argumentList];
}

#pragma mark - Properties

- (SEL)selector {
    return NULL;
}

#pragma mark - Comparing Message Patterns

- (NSUInteger)hash {
    return [super hash] ^ [self.signature hash];
}

#pragma mark - Retrieving String Representations


- (NSString *)stringValue {
    NSMutableString *description = [NSMutableString stringWithString:@"block call( "];
    NSArray *argumentFilters = self.argumentFilters;
    
    NSUInteger count = [argumentFilters count];
    
    for (NSUInteger i = 0; i < count; ++i) {
        NSString *argumentFilterString = [KWFormatter formatObject:(self.argumentFilters)[i]];
        [description appendFormat:@"%@, ", argumentFilterString];
    }
    
    [description appendFormat:@")"];
    
    return description;
}

#pragma mark - Debugging

- (NSString *)description {
    return [NSString stringWithFormat:@"argumentFilters: %@", self.argumentFilters];
}

#pragma mark - Invocation Handling

- (NSUInteger)argumentCountWithInvocation:(NSInvocation *)anInvocation {
    NSMethodSignature *signature = [anInvocation methodSignature];
    
    return [signature numberOfMessageArguments];
}

@end
