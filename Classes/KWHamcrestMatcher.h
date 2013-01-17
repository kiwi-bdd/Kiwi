//
//  KWHamcrestMatcher.h
//  Kiwi
//
//  Created by Luke Redpath on 24/01/2011.
//  Copyright 2011 Allen Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KWMatcher.h"

@protocol HCMatcher;

@interface KWHamcrestMatcher : KWMatcher {
  id<HCMatcher> hamcrestMatcher;
}

#pragma mark -
#pragma mark Configuring Matchers

- (void)match:(id<HCMatcher>)aMatcher;

@end
