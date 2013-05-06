//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWMatchVerifier.h"
#import "KWFailure.h"
#import "KWFormatter.h"
#import "KWInvocationCapturer.h"
#import "KWMatcherFactory.h"
#import "KWReporting.h"
#import "KWStringUtilities.h"
#import "KWWorkarounds.h"
#import "NSInvocation+KiwiAdditions.h"
#import "NSMethodSignature+KiwiAdditions.h"

@interface KWMatchVerifier()

#pragma mark - Properties

@property (nonatomic, readwrite, retain) id<KWMatching> endOfExampleMatcher;
@property (nonatomic, readwrite, retain) id<KWMatching> matcher;

@end

@implementation KWMatchVerifier

@synthesize matcher;

#pragma mark - Initializing

- (id)initForShouldWithCallSite:(KWCallSite *)aCallSite matcherFactory:(KWMatcherFactory *)aMatcherFactory reporter:(id<KWReporting>)aReporter {
    return [self initWithExpectationType:KWExpectationTypeShould callSite:aCallSite matcherFactory:aMatcherFactory reporter:aReporter];
}

- (id)initForShouldNotWithCallSite:(KWCallSite *)aCallSite matcherFactory:(KWMatcherFactory *)aMatcherFactory reporter:(id<KWReporting>)aReporter {
    return [self initWithExpectationType:KWExpectationTypeShouldNot callSite:aCallSite matcherFactory:aMatcherFactory reporter:aReporter];
}

- (id)initWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite matcherFactory:(KWMatcherFactory *)aMatcherFactory reporter:(id<KWReporting>)aReporter {
    if ((self = [super init])) {
        expectationType = anExpectationType;
        callSite = [aCallSite retain];
        matcherFactory = aMatcherFactory;
        reporter = aReporter;
    }

    return self;
}

+ (id)matchVerifierWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite matcherFactory:(KWMatcherFactory *)aMatcherFactory reporter:(id<KWReporting>)aReporter {
    return [[[self alloc] initWithExpectationType:anExpectationType callSite:aCallSite matcherFactory:aMatcherFactory reporter:aReporter] autorelease];
}

- (void)dealloc {
    [subject release];
    [callSite release];
    [matcher release];
    [endOfExampleMatcher release];
    [super dealloc];
}

- (NSString *)descriptionForAnonymousItNode
{
  NSString *typeString = @"";

  switch (self.expectationType) {
    case KWExpectationTypeShould:
      typeString = @"should";
      break;
    case KWExpectationTypeShouldNot:
      typeString = @"should not";
  }
  id<KWMatching> actualMatcher = (self.endOfExampleMatcher == nil) ? self.matcher : self.endOfExampleMatcher;
  return [NSString stringWithFormat:@"%@ %@", typeString, actualMatcher];
}

#pragma mark - Properties

@synthesize expectationType;
@synthesize callSite;
@synthesize matcherFactory;
@synthesize reporter;
@synthesize subject;
@synthesize endOfExampleMatcher;

#pragma mark - Verifying

- (void)verifyWithMatcher:(id<KWMatching>)aMatcher {
    @try {
        BOOL matchResult = [aMatcher evaluate];

        if (self.expectationType == KWExpectationTypeShould && !matchResult) {
            NSString *message = [aMatcher failureMessageForShould];
            KWFailure *failure = [KWFailure failureWithCallSite:self.callSite message:message];
            [self.reporter reportFailure:failure];
        } else if (self.expectationType == KWExpectationTypeShouldNot && matchResult) {
            NSString *message = [aMatcher failureMessageForShouldNot];
            KWFailure *failure = [KWFailure failureWithCallSite:self.callSite message:message];
            [self.reporter reportFailure:failure];
        }
    } @catch (NSException *exception) {
        KWFailure *failure = [KWFailure failureWithCallSite:self.callSite message:[exception description]];
        [self.reporter reportFailure:failure];
    }
}

#pragma mark - Ending Examples

- (void)exampleWillEnd {
    if (self.endOfExampleMatcher == nil)
        return;

    [self verifyWithMatcher:self.endOfExampleMatcher];
}

#pragma mark - Handling Invocations

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];

    if (signature != nil)
        return signature;

    signature = [self.matcherFactory methodSignatureForMatcherSelector:aSelector];

    if (signature != nil)
        return signature;

    // Return a dummy method signature so that problems can be handled in
    // -forwardInvocation:.
    NSString *encoding = KWEncodingForVoidMethod();
    return [NSMethodSignature signatureWithObjCTypes:[encoding UTF8String]];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
#if KW_TARGET_HAS_INVOCATION_EXCEPTION_BUG
    @try {
#endif // #if KW_TARGET_HAS_INVOCATION_EXCEPTION_BUG

    self.matcher = (id<KWMatching>)[self.matcherFactory matcherFromInvocation:anInvocation subject:self.subject];

    if (self.matcher == nil) {
      KWFailure *failure = [KWFailure failureWithCallSite:self.callSite format:@"could not create matcher for -%@",
                 NSStringFromSelector(anInvocation.selector)];
      [self.reporter reportFailure:failure];
    }
    [anInvocation invokeWithTarget:self.matcher];

#if KW_TARGET_HAS_INVOCATION_EXCEPTION_BUG
    // A matcher might have set an exception within the -invokeWithTarget, so
    // raise if one was set.
    NSException *exception = KWGetAndClearExceptionFromAcrossInvocationBoundary();
    [exception raise];
#endif // #if KW_TARGET_HAS_INVOCATION_EXCEPTION_BUG

    if ([self.matcher respondsToSelector:@selector(shouldBeEvaluatedAtEndOfExample)] && [self.matcher shouldBeEvaluatedAtEndOfExample]) {
        self.endOfExampleMatcher = self.matcher;
        self.matcher = nil;
    }
    else {
        [self verifyWithMatcher:self.matcher];
    }

#if KW_TARGET_HAS_INVOCATION_EXCEPTION_BUG
    } @catch (NSException *exception) {
        KWFailure *failure = [KWFailure failureWithCallSite:self.callSite format:[exception reason]];
        [self.reporter reportFailure:failure];
        return;
    }
#endif // #if KW_TARGET_HAS_INVOCATION_EXCEPTION_BUG
}

@end
