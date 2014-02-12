//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWBeIdenticalToMatcher.h"
#import "NSObject+KWStringRepresentation.h"

@interface KWBeIdenticalToMatcher()

#pragma mark - Properties

@property (nonatomic, readwrite, strong) id otherSubject;

@end

@implementation KWBeIdenticalToMatcher

#pragma mark - Getting Matcher Strings

+ (NSArray *)matcherStrings {
    return @[@"beIdenticalTo:"];
}

#pragma mark - Matching

- (BOOL)evaluate {
    return self.subject == self.otherSubject;
}

#pragma mark - Getting Failure Messages

- (NSString *)failureMessageForShould {
    return [NSString stringWithFormat:@"expected subject to be identical to %@ (%p), got %@ (%p)",
                                      [self.otherSubject kw_stringRepresentation],
                                      self.otherSubject,
                                      [self.subject kw_stringRepresentation],
                                      self.subject];
}

- (NSString *)failureMessageForShouldNot {
    return [NSString stringWithFormat:@"expected subject not to be identical to %@ (%p)",
                                      [self.otherSubject kw_stringRepresentation],
                                      self.otherSubject];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"be identical to %@", self.otherSubject];
}

#pragma mark - Configuring Matchers

- (void)beIdenticalTo:(id)anObject {
    self.otherSubject = anObject;
}

@end
