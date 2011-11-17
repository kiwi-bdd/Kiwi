//
//  KWAsyncVerifier.h
//  iOSFalconCore
//
//  Created by Luke Redpath on 13/01/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KWMatchVerifier.h"
#import "KWProbe.h"

#define kKW_DEFAULT_PROBE_TIMEOUT 1.0

@class KWAsyncMatcherProbe;

@interface KWAsyncVerifier : KWMatchVerifier
{
  NSTimeInterval timeout;
}
@property (nonatomic, assign) NSTimeInterval timeout;

+ (id)asyncVerifierWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite matcherFactory:(KWMatcherFactory *)aMatcherFactory reporter:(id<KWReporting>)aReporter probeTimeout:(NSTimeInterval)probeTimeout;
- (void)verifyWithProbe:(KWAsyncMatcherProbe *)aProbe;
@end

@interface KWAsyncMatcherProbe : NSObject <KWProbe>
{
  id<KWMatching> matcher;
  BOOL matchResult;
}
@property (nonatomic, readonly) id<KWMatching> matcher;

- (id)initWithMatcher:(id<KWMatching>)aMatcher;
@end
