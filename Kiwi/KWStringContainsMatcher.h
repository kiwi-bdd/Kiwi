//
//  KWStringContainsMatcher.h
//  Kiwi
//
//  Created by Stewart Gleadow on 7/06/12.
//  Copyright (c) 2012 Allen Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KWHCMatcher.h"

@interface KWStringContainsMatcher : NSObject <HCMatcher> {
  NSString *substring;
}

+ (id)matcherWithSubstring:(NSString *)aSubstring;
- (id)initWithSubstring:(NSString *)aSubstring;

@end

#define hasSubstring(substring) [KWStringContainsMatcher matcherWithSubstring:substring]
