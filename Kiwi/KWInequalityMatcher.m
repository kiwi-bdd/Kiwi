//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWInequalityMatcher.h"
#import "KWFormatter.h"

@interface KWInequalityMatcher()

#pragma mark -
#pragma mark Properties

@property (nonatomic, readwrite) KWInequalityType inequalityType;
@property (nonatomic, readwrite, retain) id otherValue;

@end

@implementation KWInequalityMatcher

#pragma mark -
#pragma mark Initializing

- (void)dealloc {
    [otherValue release];
    [super dealloc];
}

#pragma mark -
#pragma mark Properties

@synthesize inequalityType;
@synthesize otherValue;

#pragma mark -
#pragma mark Getting Matcher Strings

+ (NSArray *)matcherStrings {
    return [NSArray arrayWithObjects:@"beLessThan:",
                                     @"beLessThanOrEqualTo:",
                                     @"beGreaterThan:",
                                     @"beGreaterThanOrEqualTo:", nil];
}

#pragma mark -
#pragma mark Matching

- (BOOL)evaluate {
    if (![self.subject respondsToSelector:@selector(compare:)])
        [NSException raise:@"KWMatcherException" format:@"subject does not respond to -compare:"];
    
    NSComparisonResult result = [self.subject compare:self.otherValue];
    
    switch (result) {
        case NSOrderedSame:
            return self.inequalityType == KWInequalityTypeLessThanOrEqualTo || self.inequalityType == KWInequalityTypeGreaterThanOrEqualTo;
        case NSOrderedAscending:
            return self.inequalityType == KWInequalityTypeLessThan || self.inequalityType == KWInequalityTypeLessThanOrEqualTo;
        case NSOrderedDescending:
            return self.inequalityType == KWInequalityTypeGreaterThan || self.inequalityType == KWInequalityTypeGreaterThanOrEqualTo;
    }
    
    assert(0 && "should never reach here");
    return NO;
}

#pragma mark -
#pragma mark Getting Failure Messages

- (NSString *)comparisonPhrase {
    switch (self.inequalityType) {
        case KWInequalityTypeLessThan:
            return @"<";
        case KWInequalityTypeLessThanOrEqualTo:
            return @"<=";
        case KWInequalityTypeGreaterThan:
            return @">";
        case KWInequalityTypeGreaterThanOrEqualTo:
            return @">=";
    }
    
    assert(0 && "should never reach here");
    return nil;
}

- (NSString *)failureMessageForShould {
    return [NSString stringWithFormat:@"expected subject to be %@ %@, got %@",
                                      [self comparisonPhrase],
                                      [KWFormatter formatObject:self.otherValue],
                                      [KWFormatter formatObject:self.subject]];
}

#pragma mark -
#pragma mark Configuring Matchers

- (void)beLessThan:(id)aValue {
    self.inequalityType = KWInequalityTypeLessThan;
    self.otherValue = aValue;
}

- (void)beLessThanOrEqualTo:(id)aValue {
    self.inequalityType = KWInequalityTypeLessThanOrEqualTo;
    self.otherValue = aValue;
}

- (void)beGreaterThan:(id)aValue {
    self.inequalityType = KWInequalityTypeGreaterThan;
    self.otherValue = aValue;
}

- (void)beGreaterThanOrEqualTo:(id)aValue {
    self.inequalityType = KWInequalityTypeGreaterThanOrEqualTo;
    self.otherValue = aValue;
}

@end
