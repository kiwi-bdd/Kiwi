//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWTestCase.h"
#import <objc/runtime.h>
#import "KWDeviceInfo.h"
#import "KWExistVerifier.h"
#import "KWFailure.h"
#import "KWIntercept.h"
#import "KWMatcherFactory.h"
#import "KWMatchVerifier.h"
#import "KWAsyncVerifier.h"
#import "KWObjCUtilities.h"
#import "KWStringUtilities.h"
#import "KWVerifying.h"
#import "NSMethodSignature+KiwiAdditions.h"

@interface KWTestCase()

#pragma mark - Properties

@property (nonatomic, readonly) KWMatcherFactory *matcherFactory;
@property (nonatomic, readonly) NSMutableArray *verifiers;
@property (nonatomic, readonly) NSMutableArray *failures;
@end

@implementation KWTestCase

#pragma mark - Initializing

// Initializer used by the SenTestingKit test suite to initialize a test case
// for each test invocation returned in +testInvocations.
- (id)initWithInvocation:(NSInvocation *)anInvocation {
    if ((self = [super initWithInvocation:anInvocation])) {
        matcherFactory = [[KWMatcherFactory alloc] init];
        verifiers = [[NSMutableArray alloc] init];
        failures = [[NSMutableArray alloc] init];
    }

    return self;
}

- (void)dealloc {
    [matcherFactory release];
    [verifiers release];
    [failures release];
    [super dealloc];
}

#pragma mark - Properties

@synthesize verifiers;
@synthesize matcherFactory;
@synthesize failures;

#pragma mark - Configuring Example Environments

- (void)setUpExampleEnvironment {
    [self.matcherFactory registerMatcherClassesWithNamespacePrefix:@"KW"];
}

- (void)tearDownExampleEnvironment {
    KWClearStubsAndSpies();
}

#pragma mark - Marking Pending Examples

- (void)markPendingWithCallSite:(KWCallSite *)aCallSite {
    KWFailure *failure = [KWFailure failureWithCallSite:aCallSite format:@"PENDING"];
    [self reportFailure:failure];
}

- (void)markPendingWithCallSite:(KWCallSite *)aCallSite :(NSString *)aDescription {
    KWFailure *failure = [KWFailure failureWithCallSite:aCallSite format:@"PENDING (%@)", aDescription];
    [self reportFailure:failure];
}

#pragma mark - Adding Verifiers

- (id)addVerifier:(id<KWVerifying>)aVerifier {
    if (![self.verifiers containsObject:aVerifier])
        [self.verifiers addObject:aVerifier];

    return aVerifier;
}

- (id)addExistVerifierWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite {
    id verifier = [KWExistVerifier existVerifierWithExpectationType:anExpectationType callSite:aCallSite reporter:self];
    [self.verifiers addObject:verifier];
    return verifier;
}

- (id)addMatchVerifierWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite {
    id verifier = [KWMatchVerifier matchVerifierWithExpectationType:anExpectationType callSite:aCallSite matcherFactory:self.matcherFactory reporter:self];
    [self.verifiers addObject:verifier];
    return verifier;
}

- (id)addAsyncVerifierWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite timeout:(NSInteger)timeout {
    id verifier = [KWAsyncVerifier asyncVerifierWithExpectationType:anExpectationType callSite:aCallSite matcherFactory:self.matcherFactory reporter:self probeTimeout:timeout];
    [self.verifiers addObject:verifier];
    return verifier;
}

#pragma mark - Reporting Failures

+ (KWFailure *)tidiedFailureWithFailure:(KWFailure *)aFailure {
    if ([KWDeviceInfo isSimulator]) {
        // \uff1a is the unicode for a fill width colon, as opposed to a
        // regular :. This escape is performed so that Xcode doesn't truncate
        // the error in the build results window, which is nice for build
        // tests.
        NSString *escapedMessage = [aFailure.message stringByReplacingOccurrencesOfString:@":" withString:@"\uff1a"];
        return [KWFailure failureWithCallSite:aFailure.callSite message:escapedMessage];
    } else {
        return aFailure;
    }
}

- (void)reportFailure:(KWFailure *)aFailure; {
    [self.failures addObject:aFailure];
    KWFailure *tidiedFailure = [[self class] tidiedFailureWithFailure:aFailure];
    [self failWithException:[tidiedFailure exceptionValue]];
}

#pragma mark - Getting Invocations

// Called by the SenTestingKit test suite to get an array of invocations that
// should be run on instances of test cases.
+ (NSArray *)testInvocations {
    // Examples are methods returning void with no parameters in the receiver
    // that begin with "it" followed by an uppercase word.
    NSMutableArray *exampleInvocations = [[[NSMutableArray alloc] init] autorelease];
    unsigned int methodCount = 0;
    Method *methods = class_copyMethodList([self class], &methodCount);

    for (unsigned int i = 0; i < methodCount; i++) {
        SEL selector = method_getName(methods[i]);
        NSString *selectorString = NSStringFromSelector(selector);

        if (KWStringHasStrictWordPrefix(selectorString, @"it")) {
            const char *encoding = method_getTypeEncoding(methods[i]);
            NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:encoding];

            if ([signature numberOfMessageArguments] > 0 ||
                !KWObjCTypeEqualToObjCType([signature methodReturnType], @encode(void)))
                continue;

            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
            [invocation setSelector:selector];
            [exampleInvocations addObject:invocation];
        }
    }

    free(methods);
    return exampleInvocations;
}

#pragma mark - Running Test Cases

// Called by the SenTestingKit test suite when it is time to run the test.
- (void)invokeTest {
    NSAutoreleasePool *subPool = [[NSAutoreleasePool alloc] init];
    [self setUpExampleEnvironment];

    @try {
        [super invokeTest];

        for (id<KWVerifying> verifier in self.verifiers)
            [verifier exampleWillEnd];
    } @catch (NSException *exception) {
        [self failWithException:exception];
    }

    [self tearDownExampleEnvironment];
    [subPool release];
}

@end
