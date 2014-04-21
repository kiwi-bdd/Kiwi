//
//  KWBeKindOfClassArgumentMatcher.h
//  Kiwi
//
//  Created by Daren Desjardins on 4/21/14.
//  Copyright (c) 2014 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"
#import "KWGenericMatcher.h"

@interface KWBeKindOfClassArgumentMatcher : NSObject<KWGenericMatching>

- (instancetype)initWithClass:(Class)targetClass;
+ (instancetype)matcherForClass:(Class)targetClass;

@end
