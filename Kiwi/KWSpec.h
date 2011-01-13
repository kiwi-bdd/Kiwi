//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"
#import <SenTestingKit/SenTestingKit.h>
#import "KWBlock.h"
#import "KWExampleNodeVisitor.h"
#import "KWExpectationType.h"
#import "KWReporting.h"

#if KW_BLOCKS_ENABLED

@class KWCallSite;
@class KWContextNode;
@class KWMatcherFactory;

@protocol KWVerifying;

@interface KWSpec : SenTestCase<KWExampleNodeVisitor, KWReporting> {
@private
    KWMatcherFactory *matcherFactory;
    NSMutableArray *verifiers;
    NSMutableArray *exampleNodeStack;
}

#pragma mark -
#pragma mark Configuring Spec Environments

- (void)configureEnvironment;
- (void)cleanupEnvironment;

#pragma mark -
#pragma mark Adding Verifiers

- (id)addVerifier:(id<KWVerifying>)aVerifier;
- (id)addExistVerifierWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite;
- (id)addMatchVerifierWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite;
- (id)addAsyncVerifierWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite timeout:(NSInteger)timeout;

#pragma mark -
#pragma mark Building Example Groups

- (void)buildExampleGroups;

@end

#endif // #if KW_BLOCKS_ENABLED
