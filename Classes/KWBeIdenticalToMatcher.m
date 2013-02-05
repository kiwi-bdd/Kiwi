//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWBeIdenticalToMatcher.h"
#import "KWFormatter.h"

@interface KWBeIdenticalToMatcher()

#pragma mark -
#pragma mark Properties

@property (nonatomic, readwrite, retain) id otherSubject;

@end

@implementation KWBeIdenticalToMatcher

#pragma mark -
#pragma mark Initializing

- (void)dealloc {
    [otherSubject release];
    [super dealloc];
}

#pragma mark -
#pragma mark Properties

@synthesize otherSubject;

#pragma mark -
#pragma mark Getting Matcher Strings

+ (NSArray *)matcherStrings {
    return @[@"beIdenticalTo:"];
}

#pragma mark -
#pragma mark Matching

- (BOOL)evaluate {
    return self.subject == self.otherSubject;
}

#pragma mark -
#pragma mark Getting Failure Messages

- (NSString *)failureMessageForShould {
    return [NSString stringWithFormat:@"expected subject to be identical to %@ (%p), got %@ (%p)",
                                      [KWFormatter formatObject:self.otherSubject],
                                      self.otherSubject,
                                      [KWFormatter formatObject:self.subject],
                                      self.subject];
}

- (NSString *)failureMessageForShouldNot {
    return [NSString stringWithFormat:@"expected subject not to be identical to %@ (%p)",
                                      [KWFormatter formatObject:self.otherSubject],
                                      self.otherSubject];
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"be identical to %@", self.otherSubject];
}

#pragma mark -
#pragma mark Configuring Matchers

- (void)beIdenticalTo:(id)anObject {
    self.otherSubject = anObject;
}

@end
