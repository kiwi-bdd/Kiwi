//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWSpec.h"
#import <objc/runtime.h>
#import "KWExampleGroup.h"
#import "KWExampleGroupBuilder.h"
#import "KWIntercept.h"
#import "KWObjCUtilities.h"
#import "KWStringUtilities.h"
#import "NSMethodSignature+KiwiAdditions.h"
#import "KWFailure.h"

#define kKWINVOCATION_EXAMPLE_GROUP_KEY @"__KWExampleGroupKey"

@interface KWSpec()

#pragma mark -
#pragma mark Properties

@property (nonatomic, retain) KWExampleGroup *exampleGroup;

@end

@implementation KWSpec

@synthesize exampleGroup;

- (void)dealloc 
{
    objc_setAssociatedObject([self invocation], kKWINVOCATION_EXAMPLE_GROUP_KEY, nil, OBJC_ASSOCIATION_RETAIN);
    [exampleGroup release];
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

    NSArray *exampleGroups = [[KWExampleGroupBuilder sharedExampleGroupBuilder] buildExampleGroups:^{
        [self buildExampleGroups];
    }];
    
    NSMutableArray *invocations = [NSMutableArray array];
    
    for (KWExampleGroup *exampleGroup in exampleGroups) {
        // Add a single dummy invocation for each example group
        NSMethodSignature *methodSignature = [NSMethodSignature signatureWithObjCTypes:[KWEncodingForVoidMethod() UTF8String]];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];

        [invocations addObject:invocation];
        
        // because SenTest will modify the invocation target, we'll have to store 
        // another reference to the example group so we can retrieve it later
        objc_setAssociatedObject(invocation, kKWINVOCATION_EXAMPLE_GROUP_KEY, exampleGroup, OBJC_ASSOCIATION_RETAIN);    
    }
  
    return invocations;
}

#pragma mark -
#pragma mark Running Specs

- (void)invokeTest 
{
    self.exampleGroup = objc_getAssociatedObject([self invocation], kKWINVOCATION_EXAMPLE_GROUP_KEY);
    
    NSAutoreleasePool *subPool = [[NSAutoreleasePool alloc] init];
    
    @try {
        [self.exampleGroup runWithDelegate:self];
    } @catch (NSException *exception) {
        [self failWithException:exception];
    }
    
    [subPool release];
}

#pragma mark - KWExampleGroupDelegate methods

- (void)exampleGroup:(KWExampleGroup *)exampleGroup didFailWithFailure:(KWFailure *)failure
{
    [self failWithException:[failure exceptionValue]];
}

#pragma mark -
#pragma mark Verification proxies

+ (id)addVerifier:(id<KWVerifying>)aVerifier
{
  return [[[KWExampleGroupBuilder sharedExampleGroupBuilder] currentExampleGroup] addVerifier:aVerifier];
}

+ (id)addExistVerifierWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite
{
  return [[[KWExampleGroupBuilder sharedExampleGroupBuilder] currentExampleGroup] addExistVerifierWithExpectationType:anExpectationType callSite:aCallSite];
}

+ (id)addMatchVerifierWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite
{
  return [[[KWExampleGroupBuilder sharedExampleGroupBuilder] currentExampleGroup] addMatchVerifierWithExpectationType:anExpectationType callSite:aCallSite];
}

+ (id)addAsyncVerifierWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite timeout:(NSInteger)timeout
{
  return [[[KWExampleGroupBuilder sharedExampleGroupBuilder] currentExampleGroup] addAsyncVerifierWithExpectationType:anExpectationType callSite:aCallSite timeout:timeout];
}

@end
