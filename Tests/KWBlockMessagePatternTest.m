//
//  KWBlockMessagePatternTest.m
//  Kiwi
//
//  Created by Oleksa 'trimm' Korin on 4/26/16.
//  Copyright © 2016 Allen Ding. All rights reserved.
//

#import <Kiwi/Kiwi.h>

#import "KiwiTestConfiguration.h"
#import "NSMethodSignature+KiwiAdditions.h"
#import "TestClasses.h"
#import "KWBlockInvocation.h"

#if KW_TESTS_ENABLED

static NSString * const kKWFoo  = @"foo";
static NSString * const kKWBar  = @"bar";

typedef void(^KWTestBlock)(id, id);

@interface KWBlockMessagePatternTest : XCTestCase
@property (nonatomic) KWProxyBlock *block;
@property (nonatomic, readonly) NSMethodSignature *blockSignature;

- (NSInvocation *)blockInvocationWithArguments:(id)firstBytes, ...;

@end

@implementation KWBlockMessagePatternTest

@dynamic blockSignature;

- (NSMethodSignature *)blockSignature {
    return self.block.methodSignature;
}

- (NSInvocation *)blockInvocationWithArguments:(id)firstBytes, ... {
    NSMethodSignature *blockSignature = self.blockSignature;
    NSUInteger numberOfMessageArguments = [blockSignature numberOfMessageArguments];

    NSInvocation *invocation = [KWBlockInvocation invocationWithTarget:self.block];
    if (numberOfMessageArguments == 0)
        return invocation;
    
    va_list argumentList;
    va_start(argumentList, firstBytes);
    id bytes = firstBytes;
    
    NSUInteger vaArgCount = numberOfMessageArguments - 1;
    for (NSUInteger i = 0; i < vaArgCount; ++i) {
        [invocation setMessageArgument:&bytes atIndex:i];
        bytes = va_arg(argumentList, id);
    }
    
    [invocation setMessageArgument:&bytes atIndex:vaArgCount];
    
    va_end(argumentList);
    
    return invocation;
}

- (void)setUp {
    [super setUp];
    
    self.block = [KWProxyBlock blockWithBlock:^(id object1, id object2) { [object1 description]; }];
}

- (KWBlockMessagePattern *)messagePatternWithArguments:(id)firstArgument, ... {
    va_list argumentList;
    va_start(argumentList, firstArgument);
    
    return [KWBlockMessagePattern messagePatternWithSignature:self.block.methodSignature
                                          firstArgumentFilter:firstArgument
                                                 argumentList:argumentList];
}

- (void)testItShouldCreateMessagePatternsWithVarArgs {
    id value = [KWValue valueWithUnsignedInt:1];
    KWBlockMessagePattern *messagePattern = [self messagePatternWithArguments:nil, value];
    
    NSArray *filters = messagePattern.argumentFilters;
    
    XCTAssertEqualObjects(filters[0], [KWNull null], @"expected matching argument");
    XCTAssertEqualObjects(filters[1], value, @"expected matching argument");
}

- (void)testItShouldMatchInvocationsWithNilArguments {
    KWBlockMessagePattern *messagePattern = [self messagePatternWithArguments:kKWFoo, nil];
    
    NSInvocation *invocation = [self blockInvocationWithArguments:kKWFoo, nil];

    XCTAssertTrue([messagePattern matchesInvocation:invocation], @"expected matching invocation");
}

- (void)testItShouldMatchInvocationsWithAnyArguments {
    KWBlockMessagePattern *messagePattern = [self messagePatternWithArguments:kKWFoo, [KWAny any]];

    NSInvocation *invocation = [self blockInvocationWithArguments:kKWFoo, kKWBar];

    XCTAssertTrue([messagePattern matchesInvocation:invocation], @"expected matching invocation");
}

- (void)testItShouldMatchInvocationsWithClassArgument {
    KWBlockMessagePattern *messagePattern = [self messagePatternWithArguments:[self class], nil];
    
    NSInvocation *invocation = [self blockInvocationWithArguments:[self class], nil];
    
    XCTAssertTrue([messagePattern matchesInvocation:invocation], @"expected matching invocation");
}

- (void)testItShouldMatchInvocationsWithAnyArgumentsWhenCreatedWithMessagePatternFromInvocation {
    NSInvocation *creationInvocation = [self blockInvocationWithArguments:kKWFoo, [KWAny any]];

    KWBlockMessagePattern *messagePattern = [KWBlockMessagePattern messagePatternFromInvocation:creationInvocation];
    
    NSInvocation *invocation = [self blockInvocationWithArguments:kKWFoo, kKWBar];

    XCTAssertTrue([messagePattern matchesInvocation:invocation], @"expected matching invocation");
}

- (void)testItShouldMatchInvocationsWithAnyArgumentsForBlockParameters {
    NSInvocation *creationInvocation = [self blockInvocationWithArguments:kKWFoo, [KWAny any]];
    
    KWBlockMessagePattern *messagePattern = [KWBlockMessagePattern messagePatternFromInvocation:creationInvocation];
    
    NSInvocation *invocation = [self blockInvocationWithArguments:kKWFoo, ^{}];
    
    XCTAssertTrue([messagePattern matchesInvocation:invocation], @"expected matching invocation");
    
}

- (void)testItShouldNotMatchInvocationsWithAnyArguments {
    KWBlockMessagePattern *messagePattern = [self messagePatternWithArguments:kKWBar, [KWAny any]];
    
    NSInvocation *invocation = [self blockInvocationWithArguments:kKWFoo, kKWBar];
    
    XCTAssertFalse([messagePattern matchesInvocation:invocation], @"expected non-matching invocation");
}

- (void)testItShouldNotMatchInvocationsWithDifferentArguments {
    KWBlockMessagePattern *messagePattern = [self messagePatternWithArguments:kKWFoo, nil];

    NSInvocation *invocation = [self blockInvocationWithArguments:kKWFoo, kKWBar];

    XCTAssertFalse([messagePattern matchesInvocation:invocation], @"expected non-matching invocation");
}

- (void)testItShouldCompareMessagePatternsWithNilAndNonNilArgumentFilters {
    KWBlockMessagePattern *messagePattern1 = [KWBlockMessagePattern messagePatternWithSignature:self.blockSignature];

    NSArray *argumentFilters = @[[KWValue valueWithUnsignedInt:42]];
    KWBlockMessagePattern *messagePattern2 = [KWBlockMessagePattern messagePatternWithSignature:self.blockSignature
                                                                                argumentFilters:argumentFilters];
    
    XCTAssertFalse([messagePattern1 isEqual:messagePattern2], @"expected message patterns to compare as not equal");
    XCTAssertFalse([messagePattern2 isEqual:messagePattern1], @"expected message patterns to compare as not equal");
}

@end

#endif // #if KW_TESTS_ENABLED
