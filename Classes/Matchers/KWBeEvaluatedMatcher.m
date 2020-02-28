//
//  KWBeEvaluatedMatcher.m
//  Kiwi
//
//  Created by Oleksa 'trimm' Korin on 4/20/16.
//  Copyright © 2016 Allen Ding. All rights reserved.
//

#import "KWBeEvaluatedMatcher.h"

#import "KWBlockMessagePattern.h"
#import "KWCountType.h"
#import "KWMessageTracker.h"
#import "KWWorkarounds.h"
#import "KWProxyBlock.h"

#define KWStartVAList(listName, argument) \
    va_list listName; \
    va_start(listName, argument);

#define KWMessagePatternWithVAListAndSignature(list, argument, signature) \
    [KWBlockMessagePattern messagePatternWithSignature:(signature) \
                                   firstArgumentFilter:argument \
                                          argumentList:list]

#define KWBeEvaluatedWithCount(argument, type, countValue, signature) \
    do { \
        KWStartVAList(args, argument); \
        [(id)self beEvaluatedWithMessagePattern:KWMessagePatternWithVAListAndSignature(args, argument, (signature))  \
                                      countType:type \
                                          count:countValue]; \
    } while(0)

#define KWBeEvaluatedWithUnspecifiedCount(argument, signature) \
    do { \
        KWStartVAList(args, firstArgument) \
        id pattern = KWMessagePatternWithVAListAndSignature(args, firstArgument, (signature)); \
        [(id)self beEvaluatedWithUnspecifiedCountOfMessagePattern:pattern]; \
    } while(0)

@implementation KWBeEvaluatedMatcher

#pragma mark - Getting Matcher Strings

+ (NSArray *)matcherStrings {
    return @[@"beEvaluated",
             @"beEvaluatedWithCount",
             @"beEvaluatedWithCountAtLeast:",
             @"beEvaluatedWithCountAtMost:",
             @"beEvaluatedWithArguments:",
             @"beEvaluatedWithCount:arguments:",
             @"beEvaluatedWithCountAtLeast:arguments:",
             @"beEvaluatedWithCountAtMost:arguments:",
             @"beEvaluatedWithUnspecifiedCountOfMessagePattern:",
             @"beEvaluatedWithMessagePattern:countType:count:"];
}

#pragma mark - Configuring Matchers

- (void)beEvaluated {
    id pattern = [KWBlockMessagePattern messagePatternWithSignature:[self subjectSignature]];
    [self beEvaluatedWithUnspecifiedCountOfMessagePattern:pattern];
}

- (void)beEvaluatedWithCount:(NSUInteger)aCount {
    [self beEvaluatedWithCountType:KWCountTypeExact count:aCount];
}

- (void)beEvaluatedWithCountAtLeast:(NSUInteger)aCount {
    [self beEvaluatedWithCountType:KWCountTypeAtLeast count:aCount];
}

- (void)beEvaluatedWithCountAtMost:(NSUInteger)aCount {
    [self beEvaluatedWithCountType:KWCountTypeAtMost count:aCount];
}

- (void)beEvaluatedWithCountType:(KWCountType)aCountType count:(NSUInteger)aCount {
    id pattern = [KWBlockMessagePattern messagePatternWithSignature:[self subjectSignature]];
    
    [self beEvaluatedWithMessagePattern:pattern countType:aCountType count:aCount];
}

- (void)beEvaluatedWithUnspecifiedCountOfMessagePattern:(KWBlockMessagePattern *)messagePattern {
    KWCountType countType = self.willEvaluateAgainstNegativeExpectation ? KWCountTypeAtLeast : KWCountTypeExact;
    
    [self beEvaluatedWithCountType:countType count:1];
}

- (void)beEvaluatedWithArguments:(id)firstArgument, ... {
    KWBeEvaluatedWithUnspecifiedCount(firstArgument, [self subjectSignature]);
}

#define  KWBeEvaluatedWithCountType(type) \
    KWBeEvaluatedWithCount(firstArgument, type, aCount, [self subjectSignature])

- (void)beEvaluatedWithCount:(NSUInteger)aCount arguments:(id)firstArgument, ... {
    KWBeEvaluatedWithCountType(KWCountTypeExact);
}

- (void)beEvaluatedWithCountAtLeast:(NSUInteger)aCount arguments:(id)firstArgument, ... {
    KWBeEvaluatedWithCountType(KWCountTypeAtLeast);
}

- (void)beEvaluatedWithCountAtMost:(NSUInteger)aCount arguments:(id)firstArgument, ... {
    KWBeEvaluatedWithCountType(KWCountTypeAtMost);
}

#undef KWBeEvaluatedWithCountType

#pragma mark - Message Pattern Receiving

- (void)beEvaluatedWithMessagePattern:(KWBlockMessagePattern *)aMessagePattern countType:(KWCountType)aCountType count:(NSUInteger)aCount {
#if KW_TARGET_HAS_INVOCATION_EXCEPTION_BUG
    @try {
#endif // #if KW_TARGET_HAS_INVOCATION_EXCEPTION_BUG

    [self setMessageTrackerWithMessagePattern:aMessagePattern countType:aCountType count:aCount];
        
#if KW_TARGET_HAS_INVOCATION_EXCEPTION_BUG
    } @catch(NSException *exception) {
        KWSetExceptionFromAcrossInvocationBoundary(exception);
    }
#endif // #if KW_TARGET_HAS_INVOCATION_EXCEPTION_BUG
}

#pragma mark - Matching

- (BOOL)shouldBeEvaluatedAtEndOfExample {
    return YES;
}

- (BOOL)evaluate {
    if (![self.subject isKindOfClass:[KWProxyBlock class]])
        [NSException raise:@"KWMatcherException" format:@"subject must be a KWProxyBlock"];

    return [super evaluate];
}

- (NSMethodSignature *)subjectSignature {
    return [self.subject methodSignature];
}

@end

@implementation KWMatchVerifier (KWBeEvaluatedMatcherAdditions)

#pragma mark - Verifying

- (void)beEvaluatedWithArguments:(id)firstArgument, ... {
    KWBeEvaluatedWithUnspecifiedCount(firstArgument, [self beEvaluated_subjectSignature]);
}

#define  KWBeEvaluatedWithCountType(type) \
    KWBeEvaluatedWithCount(firstArgument, type, aCount, [self beEvaluated_subjectSignature])

- (void)beEvaluatedWithCount:(NSUInteger)aCount arguments:(id)firstArgument, ... {
    KWBeEvaluatedWithCountType(KWCountTypeExact);
}

- (void)beEvaluatedWithCountAtLeast:(NSUInteger)aCount arguments:(id)firstArgument, ... {
    KWBeEvaluatedWithCountType(KWCountTypeAtLeast);
}

- (void)beEvaluatedWithCountAtMost:(NSUInteger)aCount arguments:(id)firstArgument, ... {
    KWBeEvaluatedWithCountType(KWCountTypeAtMost);
}

#undef KWBeEvaluatedWithCountType

- (NSMethodSignature *)beEvaluated_subjectSignature {
    return [self.subject methodSignature];
}

@end

#undef KWBeEvaluatedWithUnspecifiedCount
#undef KWBeEvaluatedWithCount
#undef KWMessagePatternWithVAListAndSignature
#undef KWStartVAList
