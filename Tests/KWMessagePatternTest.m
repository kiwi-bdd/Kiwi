//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "NSInvocation+KiwiAdditions.h"

#if KW_TESTS_ENABLED

@interface KWMessagePatternTest : SenTestCase

@end

@implementation KWMessagePatternTest

- (KWMessagePattern *)messagePatternWithSelector:(SEL)aSelector arguments:(id)firstArgument, ... {
    va_list argumentList;
    va_start(argumentList, firstArgument);
    return [KWMessagePattern messagePatternWithSelector:aSelector firstArgumentFilter:firstArgument argumentList:argumentList];
}

- (void)testItShouldCreateMessagePatternsWithVarArgs {
    KWMessagePattern *messagePattern = [self messagePatternWithSelector:@selector(dictionaryWithObjects:forKeys:count:) arguments:@"foo",
                                                                                                                                  nil,
                                                                                                                                  [KWValue valueWithUnsignedInt:1]];
    STAssertEqualObjects((messagePattern.argumentFilters)[0], @"foo", @"expected matching argument");
    STAssertEqualObjects((messagePattern.argumentFilters)[1], [KWNull null], @"expected matching argument");
    STAssertEqualObjects((messagePattern.argumentFilters)[2], [KWValue valueWithUnsignedInt:1], @"expected matching argument");
}

- (void)testItShouldMatchInvocationsWithNilArguments {
    KWMessagePattern *messagePattern = [self messagePatternWithSelector:@selector(addObserver:forKeyPath:options:context:) arguments:@"foo",
                                                                                                                                     nil,
                                                                                                                                     [KWValue valueWithUnsignedInt:0],
                                                                                                                                     nil];
    NSMethodSignature *signature = [NSObject instanceMethodSignatureForSelector:@selector(addObserver:forKeyPath:options:context:)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:@selector(addObserver:forKeyPath:options:context:)];
    id observer = @"foo";
    id keyPath = nil;
    NSKeyValueObservingOptions options = 0;
    void *context = nil;
    [invocation setMessageArguments:&observer, &keyPath, &options, &context];
    STAssertTrue([messagePattern matchesInvocation:invocation], @"expected matching invocation");
}

- (void)testItShouldMatchInvocationsWithAnyArguments {
    KWMessagePattern *messagePattern = [self messagePatternWithSelector:@selector(addObserver:forKeyPath:options:context:) arguments:@"foo",
                                                                                                                                     [KWAny any],
                                                                                                                                     [KWAny any],
                                                                                                                                     nil];
    NSMethodSignature *signature = [NSObject instanceMethodSignatureForSelector:@selector(addObserver:forKeyPath:options:context:)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:@selector(addObserver:forKeyPath:options:context:)];
    id observer = @"foo";
    id keyPath = @"bar";
    NSKeyValueObservingOptions options = 1;
    void *context = nil;
    [invocation setMessageArguments:&observer, &keyPath, &options, &context];
    STAssertTrue([messagePattern matchesInvocation:invocation], @"expected matching invocation");
}

- (void)testItShouldNotMatchInvocationsWithAnyArguments {
    KWMessagePattern *messagePattern = [self messagePatternWithSelector:@selector(addObserver:forKeyPath:options:context:) arguments:@"foo",
                                                                                                                                     [KWAny any],
                                                                                                                                     [KWValue valueWithUnsignedInt:0],
                                                                                                                                     nil];
    NSMethodSignature *signature = [NSObject instanceMethodSignatureForSelector:@selector(addObserver:forKeyPath:options:context:)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:@selector(addObserver:forKeyPath:options:context:)];
    id observer = @"foo";
    id keyPath = @"bar";
    NSKeyValueObservingOptions options = 1;
    void *context = nil;
    [invocation setMessageArguments:&observer, &keyPath, &options, &context];
    STAssertTrue(![messagePattern matchesInvocation:invocation], @"expected non-matching invocation");
}

- (void)testItShouldNotMatchInvocationsWithDifferentArguments {
    KWMessagePattern *messagePattern = [self messagePatternWithSelector:@selector(addObserver:forKeyPath:options:context:) arguments:@"foo",
                                                                                                                                     nil,
                                                                                                                                     [KWValue valueWithUnsignedInt:0],
                                                                                                                                     nil];
    NSMethodSignature *signature = [NSObject instanceMethodSignatureForSelector:@selector(addObserver:forKeyPath:options:context:)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:@selector(addObserver:forKeyPath:options:context:)];
    id observer = @"foo";
    id keyPath = @"bar";
    NSKeyValueObservingOptions options = 0;
    void *context = nil;
    [invocation setMessageArguments:&observer, &keyPath, &options, &context];
    STAssertTrue(![messagePattern matchesInvocation:invocation], @"expected non-matching invocation");
}

- (void)testItShouldCompareMessagePatternsWithNilAndNonNilArgumentFilters {
    KWMessagePattern *messagePattern1 = [KWMessagePattern messagePatternWithSelector:@selector(foobar:)];
    NSArray *argumentFilters = @[[KWValue valueWithUnsignedInt:42]];
    KWMessagePattern *messagePattern2 = [KWMessagePattern messagePatternWithSelector:@selector(foobar:) argumentFilters:argumentFilters];
    STAssertFalse([messagePattern1 isEqual:messagePattern2], @"expected message patterns to compare as not equal");
    STAssertFalse([messagePattern2 isEqual:messagePattern1], @"expected message patterns to compare as not equal");
}

@end

#endif // #if KW_TESTS_ENABLED
