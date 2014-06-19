//
//  KWBeKindOfClassArgumentMatcher.m
//  Kiwi
//
//  Created by Daren Desjardins on 4/21/14.
//  Copyright (c) 2014 Allen Ding. All rights reserved.
//

#import "KWBeKindOfClassArgumentMatcher.h"

@interface KWBeKindOfClassArgumentMatcher ()

@property (nonatomic, assign) Class targetClass;

@end

@implementation KWBeKindOfClassArgumentMatcher

- (instancetype)initWithClass:(Class)targetClass {
    if(self = [super init]) {
        self.targetClass = targetClass;
    }
    return self;
}

+ (instancetype)matcherForClass:(Class)targetClass {
    return [[KWBeKindOfClassArgumentMatcher alloc] initWithClass:targetClass];
}

- (BOOL)matches:(id)item {
    return [item isKindOfClass:self.targetClass];
}

- (NSString *)description
{
    return [self.targetClass description];
}

@end
