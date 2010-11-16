//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWBeKindOfClassMatcher.h"
#import "KWFormatter.h"

@interface KWBeKindOfClassMatcher()

#pragma mark -
#pragma mark Properties

@property (nonatomic, readwrite, assign) Class targetClass;

@end

@implementation KWBeKindOfClassMatcher

#pragma mark -
#pragma mark Properties

@synthesize targetClass;

#pragma mark -
#pragma mark Getting Matcher Strings

+ (NSArray *)matcherStrings {
    return [NSArray arrayWithObject:@"beKindOfClass:"];
}

#pragma mark -
#pragma mark Matching

- (BOOL)evaluate {
    return [self.subject isKindOfClass:self.targetClass];
}

#pragma mark -
#pragma mark Getting Failure Messages

- (NSString *)failureMessageForShould {
    return [NSString stringWithFormat:@"expected subject to be kind of %@",
                                      NSStringFromClass(self.targetClass)];
}

#pragma mark -
#pragma mark Configuring Matchers

- (void)beKindOfClass:(Class)aClass {
    self.targetClass = aClass;
}

@end
