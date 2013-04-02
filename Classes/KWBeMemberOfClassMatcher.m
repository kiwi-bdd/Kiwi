//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWBeMemberOfClassMatcher.h"
#import "KWFormatter.h"

@interface KWBeMemberOfClassMatcher()

#pragma mark -
#pragma mark Properties

@property (nonatomic, readwrite, assign) Class targetClass;

@end

@implementation KWBeMemberOfClassMatcher

#pragma mark -
#pragma mark Properties

@synthesize targetClass;

#pragma mark -
#pragma mark Getting Matcher Strings

+ (NSArray *)matcherStrings {
    return @[@"beMemberOfClass:"];
}

#pragma mark -
#pragma mark Matching

- (BOOL)evaluate {
    return [self.subject isMemberOfClass:self.targetClass];
}

#pragma mark -
#pragma mark Getting Failure Messages

- (NSString *)failureMessageForShould {
    return [NSString stringWithFormat:@"expected subject to be member of %@, got %@",
                                      NSStringFromClass(self.targetClass),
                                      NSStringFromClass([self.subject class])];
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"be member of %@",
                                    NSStringFromClass(self.targetClass)];
}

#pragma mark -
#pragma mark Configuring Matchers

- (void)beMemberOfClass:(Class)aClass {
    self.targetClass = aClass;
}

@end
