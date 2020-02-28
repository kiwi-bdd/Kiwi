//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWSelectorMessagePattern.h"
#import "KWAny.h"
#import "KWFormatter.h"
#import "KWNull.h"
#import "KWObjCUtilities.h"
#import "KWValue.h"
#import "NSInvocation+KiwiAdditions.h"
#import "NSMethodSignature+KiwiAdditions.h"
#import "KWGenericMatchEvaluator.h"

@implementation KWSelectorMessagePattern

#pragma mark - Initializing

- (id)initWithSelector:(SEL)aSelector {
    return [self initWithSelector:aSelector argumentFilters:nil];
}

- (id)initWithSelector:(SEL)aSelector argumentFilters:(NSArray *)anArray {
    self = [super initWithArgumentFilters:anArray];;
    if (self) {
        _selector = aSelector;
    }

    return self;
}

- (id)initWithSelector:(SEL)aSelector firstArgumentFilter:(id)firstArgumentFilter argumentList:(va_list)argumentList {
    NSUInteger count = KWSelectorParameterCount(aSelector);

    NSArray *argumentFilters = [self argumentFiltersWithFirstArgumentFilter:firstArgumentFilter
                                                               argumentList:argumentList
                                                              argumentCount:count];

    return [self initWithSelector:aSelector argumentFilters:argumentFilters];
}

- (id)initWithInvocation:(NSInvocation *)anInvocation {
    NSArray *argumentFilters = [self argumentFiltersWithInvocation:anInvocation];
    
    return [self initWithSelector:anInvocation.selector argumentFilters:argumentFilters];
}

+ (id)messagePatternWithSelector:(SEL)aSelector {
    return [self messagePatternWithSelector:aSelector argumentFilters:nil];
}

+ (id)messagePatternWithSelector:(SEL)aSelector argumentFilters:(NSArray *)anArray {
    return [[self alloc] initWithSelector:aSelector argumentFilters:anArray];
}

+ (id)messagePatternWithSelector:(SEL)aSelector firstArgumentFilter:(id)firstArgumentFilter argumentList:(va_list)argumentList {
    return [[self alloc] initWithSelector:aSelector firstArgumentFilter:firstArgumentFilter argumentList:argumentList];
}

#pragma mark - Matching Invocations

- (BOOL)matchesInvocation:(NSInvocation *)anInvocation {
    return self.selector == [anInvocation selector] && [super matchesInvocation:anInvocation];
}

#pragma mark - Comparing Message Patterns

- (NSUInteger)hash {
    return [NSStringFromSelector(self.selector) hash];
}

- (BOOL)isEqualToMessagePattern:(KWSelectorMessagePattern *)aMessagePattern {
    if (self.selector != aMessagePattern.selector)
        return NO;

    return [super isEqualToMessagePattern:aMessagePattern];
}

#pragma mark - Retrieving String Representations

- (NSString *)selectorString {
    return NSStringFromSelector(self.selector);
}

- (NSString *)selectorAndArgumentFiltersString {
    NSMutableString *description = [[NSMutableString alloc] init];
    NSArray *components = [NSStringFromSelector(self.selector) componentsSeparatedByString:@":"];
    NSUInteger count = [components count] - 1;

    for (NSUInteger i = 0; i < count; ++i) {
        NSString *selectorComponent = components[i];
        NSString *argumentFilterString = [KWFormatter formatObject:(self.argumentFilters)[i]];
        [description appendFormat:@"%@:%@ ", selectorComponent, argumentFilterString];
    }

    return description;
}

- (NSString *)stringValue {
    if (self.argumentFilters == nil)
        return [self selectorString];
    else
        return [self selectorAndArgumentFiltersString];
}

#pragma mark - Debugging

- (NSString *)description {
    return [NSString stringWithFormat:@"selector: %@\nargumentFilters: %@",
                                      NSStringFromSelector(self.selector),
                                      self.argumentFilters];
}

#pragma mark - Invocation Handling

- (NSUInteger)argumentCountWithInvocation:(NSInvocation *)anInvocation {
    NSMethodSignature *signature = [anInvocation methodSignature];
    
    return [signature numberOfMessageArguments];
}

@end
