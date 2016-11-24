//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWBeEmptyMatcher.h"
#import "KWFormatter.h"

@interface KWBeEmptyMatcher()

#pragma mark - Properties

@property (nonatomic, readwrite, getter=isExpectsNil) BOOL expectsNil;
@property (nonatomic, readwrite) NSUInteger count;

@end

@implementation KWBeEmptyMatcher

#pragma mark - Getting Matcher Strings

+ (NSArray *)matcherStrings {
    return @[@"beNilOrEmpty", @"beEmpty"];
}

#pragma mark - Matching

- (BOOL)evaluate {
    if (self.expectsNil && self.subject == nil) {
        self.count = 0;
        return YES;
    }
    else if ([self.subject respondsToSelector:@selector(count)]) {
        self.count = [self.subject count];
        return self.count == 0;
    }
    else if ([self.subject respondsToSelector:@selector(length)]) {
        self.count = [self.subject length];
        return self.count == 0;
    }

    [NSException raise:@"KWMatcherException" format:@"subject does not respond to -count or -length"];
    return NO;
}

#pragma mark - Getting Failure Messages

- (NSString *)countPhrase {
    if (self.count == 1)
        return @"1 item";
    else
        return [NSString stringWithFormat:@"%u items", (unsigned)self.count];
}

- (NSString *)failureMessageForShould {
    return [NSString stringWithFormat:@"expected subject to %@, got %@", [self description], [self countPhrase]];
}

- (NSString *)failureMessageForShouldNot {
    return [NSString stringWithFormat:@"expected subject not to %@", [self description]];
}

- (NSString *)description {
    if (self.expectsNil) {
        return @"be nil or empty";
    }
    return @"be empty";
}

#pragma mark - Configuring Matchers

- (void)beEmpty {
    self.expectsNil = NO;
}

- (void)beNilOrEmpty {
    self.expectsNil = YES;
}

@end
