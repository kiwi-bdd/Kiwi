//
//  KWAbstractMessagePattern.m
//  Kiwi
//
//  Created by Oleksa 'trimm' Korin on 4/26/16.
//  Copyright © 2016 Allen Ding. All rights reserved.
//

#import "KWMessagePattern.h"

#import "KWNull.h"
#import "NSInvocation+KiwiAdditions.h"
#import "NSMethodSignature+KiwiAdditions.h"
#import "KWObjCUtilities.h"
#import "KWAny.h"
#import "KWValue.h"
#import "KWFormatter.h"
#import "KWGenericMatchEvaluator.h"

#import "KWBlockMessagePattern.h"
#import "KWSelectorMessagePattern.h"

@implementation KWMessagePattern

#pragma mark - Initializing

- (id)initWithArgumentFilters:(NSArray *)anArray {
    self = [super init];
    if (self) {
        if ([anArray count] > 0)
            _argumentFilters = [anArray copy];
    }
    
    return self;
}

- (id)initWithInvocation:(NSInvocation *)anInvocation {
    return [self initWithArgumentFilters:[self argumentFiltersWithInvocation:anInvocation]];
}

+ (id)messagePatternFromInvocation:(NSInvocation *)anInvocation {
    return [[self alloc] initWithInvocation:anInvocation];
}

#pragma mark - Properties

- (NSUInteger)argumentCount {
    return 0;
}

#pragma mark - Matching Invocations

- (BOOL)argumentFiltersMatchInvocationArguments:(NSInvocation *)anInvocation {
    if (self.argumentFilters == nil)
        return YES;
    
    NSMethodSignature *signature = [anInvocation methodSignature];
    NSUInteger numberOfArgumentFilters = [self.argumentFilters count];
    NSUInteger numberOfMessageArguments = [self argumentCountWithInvocation:anInvocation];
    
    for (NSUInteger i = 0; i < numberOfMessageArguments && i < numberOfArgumentFilters; ++i) {
        const char *objCType = [signature messageArgumentTypeAtIndex:i];
        id __autoreleasing object = nil;
        
        // Extract message argument into object (wrapping values if neccesary)
        if (KWObjCTypeIsObject(objCType) || KWObjCTypeIsClass(objCType)) {
            [anInvocation getMessageArgument:&object atIndex:i];
        } else {
            NSData *data = [anInvocation messageArgumentDataAtIndex:i];
            object = [KWValue valueWithBytes:[data bytes] objCType:objCType];
        }
        
        // Match argument filter to object
        id argumentFilter = (self.argumentFilters)[i];
        
        if ([argumentFilter isEqual:[KWAny any]]) {
            continue;
        }
        
        if ([KWGenericMatchEvaluator isGenericMatcher:argumentFilter]) {
            id matcher = argumentFilter;
            if ([object isKindOfClass:[KWValue class]] && [object isNumeric]) {
                NSNumber *number = [object numberValue];
                if (![KWGenericMatchEvaluator genericMatcher:matcher matches:number]) {
                    return NO;
                }
            } else if (![KWGenericMatchEvaluator genericMatcher:matcher matches:object]) {
                return NO;
            }
        } else if ([argumentFilter isEqual:[KWNull null]]) {
            if (!KWObjCTypeIsPointerLike(objCType)) {
                [NSException raise:@"KWMessagePatternException" format:@"nil was specified as an argument filter, but argument(%d) is not a pointer for @selector(%@)", (int)(i + 1), NSStringFromSelector([anInvocation selector])];
            }
            void *p = nil;
            [anInvocation getMessageArgument:&p atIndex:i];
            if (p != nil)
                return NO;
        } else if (![argumentFilter isEqual:object]) {
            return NO;
        }
    }
    
    return YES;
}

- (BOOL)matchesInvocation:(NSInvocation *)anInvocation {
    return [self argumentFiltersMatchInvocationArguments:anInvocation];
}

#pragma mark - Comparing Message Patterns

- (NSUInteger)hash {
    return [self.argumentFilters hash];;
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[self class]])
        return NO;
    
    return [self isEqualToMessagePattern:object];
}

- (BOOL)isEqualToMessagePattern:(KWMessagePattern *)aMessagePattern {
    if (self.argumentFilters == nil && aMessagePattern.argumentFilters == nil)
        return YES;
    
    return [self.argumentFilters isEqualToArray:aMessagePattern.argumentFilters];
}

#pragma mark - Retrieving String Representations

- (NSString *)stringValue {
    return nil;
}

#pragma mark - Debugging

- (NSString *)description {
    return [NSString stringWithFormat:@"argumentFilters: %@", self.argumentFilters];
}

#pragma mark - Argument Filters Creation

- (NSArray *)argumentFiltersWithInvocation:(NSInvocation *)anInvocation {
    NSMethodSignature *signature = [anInvocation methodSignature];
    NSUInteger numberOfMessageArguments = [self argumentCountWithInvocation:anInvocation];
    NSMutableArray *argumentFilters = nil;
    
    if (numberOfMessageArguments > 0) {
        argumentFilters = [[NSMutableArray alloc] initWithCapacity:numberOfMessageArguments];
        
        for (NSUInteger i = 0; i < numberOfMessageArguments; ++i) {
            const char *type = [signature messageArgumentTypeAtIndex:i];
            void* argumentDataBuffer = malloc(KWObjCTypeLength(type));
            [anInvocation getMessageArgument:argumentDataBuffer atIndex:i];
            id object = nil;
            if(*(__unsafe_unretained id*)argumentDataBuffer != [KWAny any] && !KWObjCTypeIsObject(type)) {
                NSData *data = [anInvocation messageArgumentDataAtIndex:i];
                object = [KWValue valueWithBytes:[data bytes] objCType:type];
            } else {
                object = *(__unsafe_unretained id*)argumentDataBuffer;
                
                if (object != [KWAny any] && KWObjCTypeIsBlock(type)) {
                    object = [object copy]; // Converting NSStackBlock to NSMallocBlock
                }
            }
            
            [argumentFilters addObject:(object != nil) ? object : [KWNull null]];
            
            free(argumentDataBuffer);
        }
    }
    
    return argumentFilters;
}

- (NSArray *)argumentFiltersWithFirstArgumentFilter:(id)firstArgumentFilter
                                       argumentList:(va_list)argumentList
                                      argumentCount:(NSUInteger)count
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:count];
    [array addObject:(firstArgumentFilter != nil) ? firstArgumentFilter : [KWNull null]];
    
    for (NSUInteger i = 1; i < count; ++i) {
        id object = va_arg(argumentList, id);
        [array addObject:(object != nil) ? object : [KWNull null]];
    }
    
    va_end(argumentList);
    
    return array;
}

#pragma mark - Invocation Handling

- (NSUInteger)argumentCountWithInvocation:(NSInvocation *)invocation {
    return 0;
}

@end

// cluster methods for KWSelectorMessagePattern
@implementation KWMessagePattern (KWSelectorMessagePatternCluster)

#pragma mark - Initializing

- (id)initWithSelector:(SEL)aSelector {
    return [[KWSelectorMessagePattern alloc] initWithSelector:aSelector];
}

- (id)initWithSelector:(SEL)aSelector argumentFilters:(NSArray *)anArray {
    return [[KWSelectorMessagePattern alloc] initWithSelector:aSelector argumentFilters:anArray];
}

- (id)initWithSelector:(SEL)aSelector
   firstArgumentFilter:(id)firstArgumentFilter
          argumentList:(va_list)argumentList
{
    return [[KWSelectorMessagePattern alloc] initWithSelector:aSelector
                                          firstArgumentFilter:firstArgumentFilter
                                                 argumentList:argumentList];
}

+ (id)messagePatternWithSelector:(SEL)aSelector {
    return [KWSelectorMessagePattern messagePatternWithSelector:aSelector];
}

+ (id)messagePatternWithSelector:(SEL)aSelector argumentFilters:(NSArray *)anArray {
    return [KWSelectorMessagePattern messagePatternWithSelector:aSelector argumentFilters:anArray];
}

+ (id)messagePatternWithSelector:(SEL)aSelector
             firstArgumentFilter:(id)firstArgumentFilter
                    argumentList:(va_list)argumentList
{
    return [KWSelectorMessagePattern messagePatternWithSelector:aSelector
                                            firstArgumentFilter:firstArgumentFilter
                                                   argumentList:argumentList];
}

@end

// cluster methods for KWBlockMessagePattern
@implementation  KWMessagePattern (KWBlockMessagePatternCluster)

#pragma mark - Initializing

- (id)initWithSignature:(NSMethodSignature *)signature {
    return [[KWBlockMessagePattern alloc] initWithSignature:signature];
}

- (id)initWithSignature:(NSMethodSignature *)signature argumentFilters:(NSArray *)anArray {
    return [[KWBlockMessagePattern alloc] initWithSignature:signature argumentFilters:anArray];
}
- (id)initWithSignature:(NSMethodSignature *)signature
    firstArgumentFilter:(id)firstArgumentFilter
           argumentList:(va_list)argumentList
{
    return [[KWBlockMessagePattern alloc] initWithSignature:signature
                                        firstArgumentFilter:firstArgumentFilter
                                               argumentList:argumentList];
}

+ (id)messagePatternWithSignature:(NSMethodSignature *)signature {
    return [KWBlockMessagePattern messagePatternWithSignature:signature];
}

+ (id)messagePatternWithSignature:(NSMethodSignature *)signature argumentFilters:(NSArray *)anArray {
    return [KWBlockMessagePattern messagePatternWithSignature:signature argumentFilters:anArray];
}

+ (id)messagePatternWithSignature:(NSMethodSignature *)signature
              firstArgumentFilter:(id)firstArgumentFilter
                     argumentList:(va_list)argumentList
{
    return [KWBlockMessagePattern messagePatternWithSignature:signature
                                          firstArgumentFilter:firstArgumentFilter
                                                 argumentList:argumentList];
}

@end
