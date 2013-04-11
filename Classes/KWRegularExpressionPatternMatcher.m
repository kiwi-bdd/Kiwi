//
//  KWRegularExpressionPatternMatcher.m
//  Kiwi
//
//  Created by Kristopher Johnson on 4/11/13.
//  Copyright (c) 2013 Allen Ding. All rights reserved.
//

#import "KWRegularExpressionPatternMatcher.h"
#import "KWFormatter.h"


@interface KWRegularExpressionPatternMatcher ()

@property (nonatomic, copy) NSString *pattern;

@end


@implementation KWRegularExpressionPatternMatcher

- (void)dealloc {
    self.pattern = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Getting Matcher Strings

+ (NSArray *)matcherStrings {
    return @[@"matchPattern:"];
}

#pragma mark -
#pragma mark Matching

- (BOOL)evaluate {
    if (![self.subject isKindOfClass:[NSString class]]) {
        return NO;
    }
    NSString *subjectString = (NSString *)self.subject;
    NSRange subjectStringRange = NSMakeRange(0, subjectString.length);
    
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:self.pattern
                                                                           options:0
                                                                             error:&error];
    if (!regex) {
        NSLog(@"%s: Unable to create regular expression for pattern \"%@\": %@",
              __PRETTY_FUNCTION__, self.pattern, [error localizedDescription]);
        return NO;
    }
    
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:subjectString
                                                        options:0
                                                          range:subjectStringRange];
    return (numberOfMatches == 1);
}

#pragma mark -
#pragma mark Getting Failure Messages

- (NSString *)failureMessageForShould {
    return [NSString stringWithFormat:@"%@ did not match pattern \"%@\"",
            [KWFormatter formatObject:self.subject],
            self.pattern];
}

- (NSString *)failureMessageForShouldNot {
    return [NSString stringWithFormat:@"expected subject not to match pattern \"%@\"",
            self.pattern];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"match pattern \"%@\"", self.pattern];
}

- (void)matchPattern:(NSString *)pattern {
    self.pattern = pattern;
}

@end
