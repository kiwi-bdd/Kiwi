//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"
#import "KWMatching.h"

@interface KWMatcher : NSObject<KWMatching> {
@protected
    id subject;
}

#pragma mark - Initializing

- (id)initWithSubject:(id)anObject;

+ (id)matcherWithSubject:(id)anObject;

#pragma mark - Properties

@property (nonatomic, readonly) id subject;

#pragma mark - Getting Matcher Strings

+ (NSArray *)matcherStrings;

#pragma mark - Getting Matcher Compatability

+ (BOOL)canMatchSubject:(id)anObject;

#pragma mark - Matching

- (BOOL)evaluate;

#pragma mark - Getting Failure Messages

- (NSString *)failureMessageForShould;
- (NSString *)failureMessageForShouldNot;

@end
