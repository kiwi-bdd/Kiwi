//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWEqualMatcher.h"
#import "KWFormatter.h"

@interface KWEqualMatcher()

#pragma mark -
#pragma mark Properties

@property (nonatomic, readwrite, retain) id otherSubject;

@end

@implementation KWEqualMatcher

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
    return [NSArray arrayWithObjects:@"equal:", nil];
}

#pragma mark -
#pragma mark Matching

- (BOOL)evaluate {
    return [self.subject isEqual:self.otherSubject];
}

#pragma mark -
#pragma mark Getting Failure Messages

- (NSString *)failureMessageForShould {
    return [NSString stringWithFormat:@"expected subject to equal %@, got %@",
                                      [KWFormatter formatObject:self.otherSubject],
                                      [KWFormatter formatObject:self.subject]];
}

- (NSString *)failureMessageForShouldNot {
    return [NSString stringWithFormat:@"expected subject not to equal %@",
                                      [KWFormatter formatObject:self.otherSubject]];
}

#pragma mark -
#pragma mark Configuring Matchers

- (void)equal:(id)anObject {
    self.otherSubject = anObject;
}

@end
