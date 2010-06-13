//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWBeTrueMatcher.h"

@interface KWBeTrueMatcher()

#pragma mark -
#pragma mark Properties

@property (nonatomic, readwrite) BOOL expectedValue;

@end

@implementation KWBeTrueMatcher

#pragma mark -
#pragma mark Properties

@synthesize expectedValue;

#pragma mark -
#pragma mark Getting Matcher Strings

+ (NSArray *)matcherStrings {
    return [NSArray arrayWithObjects:@"beTrue", @"beFalse", @"beYes", @"beNo", nil];
}

#pragma mark -
#pragma mark Matching

- (BOOL)evaluate {
    if (![self.subject respondsToSelector:@selector(boolValue)])
        [NSException raise:@"KWMatcherException" format:@"subject does not respond to -boolValue"];
    
    return [self.subject boolValue] == self.expectedValue;
}

#pragma mark -
#pragma mark Getting Failure Messages

- (NSString *)failureMessageForShould {
    return [NSString stringWithFormat:@"expected subject to be %@",
                                       expectedValue ? @"true" : @"false"];
}

#pragma mark -
#pragma mark Configuring Matchers

- (void)beTrue {
    self.expectedValue = YES;
}

- (void)beFalse {
    self.expectedValue = NO;
}

- (void)beYes {
    self.expectedValue = YES;
}

- (void)beNo {
    self.expectedValue = NO;
}

@end
