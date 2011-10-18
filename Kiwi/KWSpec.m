//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWSpec.h"
#import <objc/runtime.h>
#import "KWExample.h"
#import "KWExampleGroupBuilder.h"
#import "KWIntercept.h"
#import "KWObjCUtilities.h"
#import "KWStringUtilities.h"
#import "NSMethodSignature+KiwiAdditions.h"
#import "KWFailure.h"
#import "KWExampleSuite.h"


@interface KWSpec()

#pragma mark -
#pragma mark Properties

@property (nonatomic, retain) KWExample *example;

@end

@implementation KWSpec

@synthesize example;

- (void)dealloc 
{
    [example release];
    [super dealloc];
}

/* This method is only implemented by sub-classes */

+ (void)buildExampleGroups {}

- (NSString *)description
{
    return [NSString stringWithFormat:@"-[%@ example]", NSStringFromClass([self class])];
}

#pragma mark -
#pragma mark Getting Invocations

/* Called by the SenTestingKit test suite to get an array of invocations that
   should be run on instances of test cases. */

+ (NSArray *)testInvocations 
{
    SEL selector = @selector(buildExampleGroups);

    // Only return invocation if the receiver is a concrete spec that has overridden -buildExampleGroups.
    if ([self methodForSelector:selector] == [KWSpec methodForSelector:selector])
        return nil;

    KWExampleSuite *exampleSuite = [[KWExampleGroupBuilder sharedExampleGroupBuilder] buildExampleGroups:^{
        [self buildExampleGroups];
    }];
  
    return [exampleSuite invocationsForTestCase];
}

#pragma mark -
#pragma mark Running Specs

- (void)invokeTest 
{
    self.example = [[self invocation] kw_example];

    NSAutoreleasePool *subPool = [[NSAutoreleasePool alloc] init];

    @try {
        [self.example runWithDelegate:self];
    } @catch (NSException *exception) {
        [self failWithException:exception];
    }
    
    [[self invocation] kw_setExample:nil];
    
    [subPool release];
}

#pragma mark - KWExampleGroupDelegate methods

- (void)example:(KWExample *)example didFailWithFailure:(KWFailure *)failure
{
    [self failWithException:[failure exceptionValue]];
}

#pragma mark -
#pragma mark Verification proxies

+ (id)addVerifier:(id<KWVerifying>)aVerifier
{
  return [[[KWExampleGroupBuilder sharedExampleGroupBuilder] currentExample] addVerifier:aVerifier];
}

+ (id)addExistVerifierWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite
{
  return [[[KWExampleGroupBuilder sharedExampleGroupBuilder] currentExample] addExistVerifierWithExpectationType:anExpectationType callSite:aCallSite];
}

+ (id)addMatchVerifierWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite
{
  return [[[KWExampleGroupBuilder sharedExampleGroupBuilder] currentExample] addMatchVerifierWithExpectationType:anExpectationType callSite:aCallSite];
}

+ (id)addAsyncVerifierWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite timeout:(NSInteger)timeout
{
  return [[[KWExampleGroupBuilder sharedExampleGroupBuilder] currentExample] addAsyncVerifierWithExpectationType:anExpectationType callSite:aCallSite timeout:timeout];
}

@end
