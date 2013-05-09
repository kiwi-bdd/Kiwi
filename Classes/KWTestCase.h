//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"
#import <SenTestingKit/SenTestingKit.h>
#import "KWExpectationType.h"
#import "KWReporting.h"

@class KWCallSite;
@class KWMatcherFactory;

@protocol KWVerifying;

// Deprecated. This is here just in case blocks are not enabled.
@interface KWTestCase : SenTestCase<KWReporting>

#pragma mark - Configuring Example Environments

- (void)setUpExampleEnvironment;
- (void)tearDownExampleEnvironment;

#pragma mark - Marking Pending Examples

- (void)markPendingWithCallSite:(KWCallSite *)aCallSite;
- (void)markPendingWithCallSite:(KWCallSite *)aCallSite :(NSString *)aDescription;

#pragma mark - Adding Verifiers

- (id)addVerifier:(id<KWVerifying>)aVerifier;
- (id)addExistVerifierWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite;
- (id)addMatchVerifierWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite;
- (id)addAsyncVerifierWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite timeout:(NSInteger)timeout;

@end
