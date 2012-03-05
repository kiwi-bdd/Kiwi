//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWBeSubclassOfClassMatcher.h"
#import "KWFormatter.h"

@interface KWBeSubclassOfClassMatcher()

#pragma mark -
#pragma mark Properties

@property (nonatomic, readwrite, assign) Class targetClass;

@end

@implementation KWBeSubclassOfClassMatcher

#pragma mark -
#pragma mark Properties

@synthesize targetClass;

#pragma mark -
#pragma mark Getting Matcher Strings

+ (NSArray *)matcherStrings {
    return [NSArray arrayWithObject:@"beSubclassOfClass:"];
}

#pragma mark -
#pragma mark Matching

- (BOOL)evaluate {
    return [self.subject isSubclassOfClass:self.targetClass];
}

#pragma mark -
#pragma mark Getting Failure Messages

- (NSString *)failureMessageForShould {
    return [NSString stringWithFormat:@"expected subject to be subclass of %@",
                                      NSStringFromClass(self.targetClass)];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"be member of %@",
                                      NSStringFromClass(self.targetClass)];
}

#pragma mark -
#pragma mark Configuring Matchers

- (void)beSubclassOfClass:(Class)aClass {
    self.targetClass = aClass;
}

@end
