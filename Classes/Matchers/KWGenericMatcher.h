//
//  KWGenericMatcher.h
//  Kiwi
//
//  Created by Luke Redpath on 24/01/2011.
//  Copyright 2011 Allen Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KWMatcher.h"

@protocol KWGenericMatching <NSObject>

- (BOOL)matches:(id)object;

@end

@interface KWGenericMatcher : KWMatcher

#pragma mark - Configuring Matchers

// Note using id<KWGenericMatching> breaks OCHamcrest integration with Kiwi and cause
// warning: sending 'id<HCMatcher>' to parameter of incompatible type 'id<KWGenericMatching>'
// as Hamcrest has own HCMatcher protocol and unaware of KWGenericMatching protocol.
// Passing generic id object works.
// - (void)match:(id<KWGenericMatching>)aMatcher; // breaks integration with https://github.com/hamcrest/OCHamcrest
- (void)match:(id)aMatcher;
@end
