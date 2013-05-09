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

#pragma mark - Properties

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

/* Reported by XCode SenTestingKit Runner before and after invocation of the test
   Use camel case to make method friendly names from example description
 */

- (NSString *)description
{
    KWExample *currentExample = self.example ? self.example : [[self invocation] kw_example];
    NSString *name = [currentExample descriptionWithContext];
    
    // CamelCase the string
    NSArray *words = [name componentsSeparatedByString:@" "];
    name = @"";
    for (NSString *word in words) {
        if ([word length] < 1)
        {
            continue;
        }
        name = [name stringByAppendingString:[[word substringToIndex:1] uppercaseString]];
        name = [name stringByAppendingString:[word substringFromIndex:1]];
    }
    
    // Replace the commas with underscores to separate the levels of context
    name = [name stringByReplacingOccurrencesOfString:@"," withString:@"_"];
    
    // Strip out characters not legal in function names
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^a-zA-Z0-9_]*" options:0 error:&error];
    name = [regex stringByReplacingMatchesInString:name options:0 range:NSMakeRange(0, name.length) withTemplate:@""];

    return [NSString stringWithFormat:@"-[%@ %@]", NSStringFromClass([self class]), name];
}

#pragma mark - Getting Invocations

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

#pragma mark - Running Specs

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

#pragma mark - Verification proxies

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
