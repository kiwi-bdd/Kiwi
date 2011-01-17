//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"

@protocol KWMatching<NSObject>

#pragma mark -
#pragma mark Initializing

- (id)initWithSubject:(id)anObject;

#pragma mark -
#pragma mark Getting Matcher Strings

+ (NSArray *)matcherStrings;

#pragma mark -
#pragma mark Getting Matcher Compatability

+ (BOOL)canMatchSubject:(id)anObject;

#pragma mark -
#pragma mark Matching

@optional

- (BOOL)shouldBeEvaluatedAtEndOfExample;
- (BOOL)willEvaluateMultipleTimes;
- (void)setWillEvaluateMultipleTimes:(BOOL)shouldEvaluateMultipleTimes;

@required

- (BOOL)evaluate;

#pragma mark -
#pragma mark Getting Failure Messages

- (NSString *)failureMessageForShould;
- (NSString *)failureMessageForShouldNot;

@end
