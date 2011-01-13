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

@class KWAsyncMatcherProbe;

@interface KWAsyncVerifier : KWMatchVerifier 
{}
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
