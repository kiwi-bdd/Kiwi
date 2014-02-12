//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWEqualMatcher.h"
#import "KWValue.h"
#import "NSObject+KWStringRepresentation.h"

@interface KWEqualMatcher()

#pragma mark - Properties

@property (nonatomic, readwrite, strong) id otherSubject;

@end

@implementation KWEqualMatcher

#pragma mark - Initializing


#pragma mark - Properties

@synthesize otherSubject;

#pragma mark - Getting Matcher Strings

+ (NSArray *)matcherStrings {
    return @[@"equal:"];
}

#pragma mark - Matching

- (BOOL)evaluate {
    /** handle this as a special case; KWValue supports NSNumber equality but not vice-versa **/
    if ([self.subject isKindOfClass:[NSNumber class]] && [self.otherSubject isKindOfClass:[KWValue class]]) {
        return [self.otherSubject isEqual:self.subject];
    }
    return [self.subject isEqual:self.otherSubject];
}

#pragma mark - Getting Failure Messages

- (NSString *)failureMessageForShould {
    return [NSString stringWithFormat:@"expected subject to equal %@, got %@",
                                      [self.otherSubject kw_stringRepresentationWithClass],
                                      [self.subject kw_stringRepresentationWithClass]];
}

- (NSString *)failureMessageForShouldNot {
    return [NSString stringWithFormat:@"expected subject not to equal %@",
                                      [self.otherSubject kw_stringRepresentationWithClass]];
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"equal %@", [self.otherSubject kw_stringRepresentationWithClass]];
}

#pragma mark - Configuring Matchers

- (void)equal:(id)anObject {
    self.otherSubject = anObject;
}

@end
