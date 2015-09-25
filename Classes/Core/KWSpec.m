//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWSpec.h"
#import "KWCallSite.h"
#import "KWExample.h"
#import "KWExampleSuiteBuilder.h"
#import "KWFailure.h"
#import "KWExampleSuite.h"

#import <objc/runtime.h>

@interface KWSpec()

@property (nonatomic, strong) KWExample *currentExample;

@end

@implementation KWSpec

/*
 * In Xcode 7, XCTest behaves like this:
 * First, it tries to find all invocations, and +testInvocations method is called
 * Secondly, KWSpec class is checked again for available tests and for each selector, +testCaseWithSelector: method called
 *   Default XCTest implementation creates it's own NSInvocation, differs from those were created in +testInvocations method
 *   Since this invocation wasn't created by Kiwi, it doesn't have associated kw_example, and incorrect name is returned [[KWSepc (null])
 *
 */
+ (id)testCaseWithSelector:(SEL)selector {
    static NSMutableDictionary *testInvocationsPerClass;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        testInvocationsPerClass = [[NSMutableDictionary alloc] init];
    });
    NSArray *testInvocations = testInvocationsPerClass[NSStringFromClass(self)];
    if (!testInvocations) {
        testInvocations = [self testInvocations];
        testInvocationsPerClass[NSStringFromClass(self)] = testInvocations;
    }

    for (NSInvocation *invocation in testInvocations) {
        if (sel_isEqual(invocation.selector,selector)) {
            return [[self alloc] initWithInvocation:invocation];
        }
    }

    // Falling back to default implementation, if we didn't found invocation for this selector
    return [super testCaseWithSelector:selector];
}

/* Methods are only implemented by sub-classes */

+ (NSString *)file { return nil; }

+ (void)buildExampleGroups {}

- (NSString *)name {
    return [self description];
}

/* Use camel case to make method friendly names from example description. */

- (NSString *)description {
    KWExample *currentExample = self.currentExample ?: self.invocation.kw_example;
    return [NSString stringWithFormat:@"-[%@ %@]", NSStringFromClass([self class]), currentExample.selectorName];
}

#pragma mark - Getting Invocations

/* Called by the XCTest to get an array of invocations that
   should be run on instances of test cases. */

+ (NSArray *)testInvocations {
    SEL buildExampleGroups = @selector(buildExampleGroups);

    // Only return invocation if the receiver is a concrete spec that has overridden -buildExampleGroups.
    if ([self methodForSelector:buildExampleGroups] == [KWSpec methodForSelector:buildExampleGroups])
        return nil;

    KWExampleSuite *exampleSuite = [[KWExampleSuiteBuilder sharedExampleSuiteBuilder] buildExampleSuite:^{
        [self buildExampleGroups];
    }];

    NSMutableArray *invocations = [NSMutableArray new];
    for (KWExample *example in exampleSuite) {
        SEL selector = [self addInstanceMethodForExample:example];
        NSInvocation *invocation = [self invocationForExample:example selector:selector];
        [invocations addObject:invocation];
    }

    return invocations;
}

+ (SEL)addInstanceMethodForExample:(KWExample *)example {
    Method method = class_getInstanceMethod(self, @selector(runExample));
    SEL selector = NSSelectorFromString(example.selectorName);
    IMP implementation = method_getImplementation(method);
    const char *types = method_getTypeEncoding(method);
    class_addMethod(self, selector, implementation, types);
    return selector;
}

+ (NSInvocation *)invocationForExample:(KWExample *)example selector:(SEL)selector {
    NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:"v@:"];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.kw_example = example;
    invocation.selector = selector;
    return invocation;
}

#pragma mark - Message forwarding

// Inside `SPEC_BEGIN`/`SPEC_END`, `self` references the spec class object but
// ultimately needs to instead behave like an _instance_ of `KWSpec`. The current
// example has a reference to the running test case via its delegate, and so
// forwarding messages there enables messages sent to `self` from within an
// example to behave just like the test case instance.
//
// This is useful, for example, because the `XCTAssert*` macros require a `self`
// that is a kind of `XCTestCase`.
+ (id)forwardingTargetForSelector:(SEL)aSelector {
    KWExample *example = [[KWExampleSuiteBuilder sharedExampleSuiteBuilder] currentExample];

    if ([example respondsToSelector:aSelector]) {
        return example;
    } else {
        return [super forwardingTargetForSelector:aSelector];
    }
}

+ (BOOL)respondsToSelector:(SEL)aSelector {
    if ([super respondsToSelector:aSelector]) {
        return YES;
    }

    KWExample *example = [[KWExampleSuiteBuilder sharedExampleSuiteBuilder] currentExample];
    return [example respondsToSelector:aSelector];
}

#pragma mark - Running Specs

- (void)runExample {
    self.currentExample = self.invocation.kw_example;

    @autoreleasepool {
        @try {
            [self.currentExample runWithDelegate:self];
        } @catch (NSException *exception) {
            [self recordFailureWithDescription:exception.description inFile:@"" atLine:0 expected:NO];
        }

        self.invocation.kw_example = nil;
    }
}

#pragma mark - KWExampleGroupDelegate methods

- (void)example:(KWExample *)example didFailWithFailure:(KWFailure *)failure {
    [self recordFailureWithDescription:failure.message
                                inFile:failure.callSite.filename
                                atLine:failure.callSite.lineNumber
                              expected:NO];
}

#pragma mark - Verification proxies

+ (id)addVerifier:(id<KWVerifying>)aVerifier {
    return [[[KWExampleSuiteBuilder sharedExampleSuiteBuilder] currentExample] addVerifier:aVerifier];
}

+ (id)addExistVerifierWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite {
    return [[[KWExampleSuiteBuilder sharedExampleSuiteBuilder] currentExample] addExistVerifierWithExpectationType:anExpectationType callSite:aCallSite];
}

+ (id)addMatchVerifierWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite {
    return [[[KWExampleSuiteBuilder sharedExampleSuiteBuilder] currentExample] addMatchVerifierWithExpectationType:anExpectationType callSite:aCallSite];
}

+ (id)addAsyncVerifierWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite timeout:(NSTimeInterval)timeout shouldWait:(BOOL)shouldWait {
    return [[[KWExampleSuiteBuilder sharedExampleSuiteBuilder] currentExample] addAsyncVerifierWithExpectationType:anExpectationType callSite:aCallSite timeout:timeout shouldWait: shouldWait];
}

@end
