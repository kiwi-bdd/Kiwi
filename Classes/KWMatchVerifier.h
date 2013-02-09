//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"
#import "KWExpectationType.h"
#import "KWVerifying.h"

@class KWCallSite;
@class KWMatcherFactory;

@protocol KWMatching;
@protocol KWReporting;

@interface KWMatchVerifier : NSObject<KWVerifying> {
@private
    KWExpectationType expectationType;
    KWCallSite *callSite;
    KWMatcherFactory *__unsafe_unretained matcherFactory;
    id<KWReporting> __unsafe_unretained reporter;
    id subject;
    id<KWMatching> endOfExampleMatcher;
}

#pragma mark -
#pragma mark Properties

@property (nonatomic, readonly) KWExpectationType expectationType;
@property (nonatomic, readonly) KWCallSite *callSite;
@property (unsafe_unretained, nonatomic, readonly) KWMatcherFactory *matcherFactory;
@property (unsafe_unretained, nonatomic, readonly) id<KWReporting> reporter;
@property (nonatomic, readwrite, strong) id subject;

#pragma mark -
#pragma mark Initializing

- (id)initForShouldWithCallSite:(KWCallSite *)aCallSite matcherFactory:(KWMatcherFactory *)aMatcherFactory reporter:(id<KWReporting>)aReporter;
- (id)initForShouldNotWithCallSite:(KWCallSite *)aCallSite matcherFactory:(KWMatcherFactory *)aMatcherFactory reporter:(id<KWReporting>)aReporter;
- (id)initWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite matcherFactory:(KWMatcherFactory *)aMatcherFactory reporter:(id<KWReporting>)aReporter;

+ (id)matchVerifierWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite matcherFactory:(KWMatcherFactory *)aMatcherFactory reporter:(id<KWReporting>)aReporter;

@end
