//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWExistVerifier.h"
#import "KWFailure.h"
#import "KWFormatter.h"
#import "KWReporting.h"

@interface KWExistVerifier()

#pragma mark - Properties

@property (nonatomic, readonly) KWExpectationType expectationType;
@property (nonatomic, readonly) KWCallSite *callSite;
@property (nonatomic, readonly) id<KWReporting> reporter;

@end

@implementation KWExistVerifier

#pragma mark - Initializing

- (id)initWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite reporter:(id<KWReporting>)aReporter {
    if ((self = [super init])) {
        expectationType = anExpectationType;
        callSite = [aCallSite retain];
        reporter = aReporter;
    }

    return self;
}

+ (id)existVerifierWithExpectationType:(KWExpectationType)anExpectationType callSite:(KWCallSite *)aCallSite reporter:(id<KWReporting>)aReporter {
    return [[[self alloc] initWithExpectationType:anExpectationType callSite:aCallSite reporter:aReporter] autorelease];
}

- (void)dealloc {
    [callSite release];
    [subject release];
    [super dealloc];
}

- (NSString *)descriptionForAnonymousItNode
{
  if (self.expectationType == KWExpectationTypeShould) {
    return @"should exist";
  }
  return @"should not exist";
}

#pragma mark - Properties

@synthesize expectationType;
@synthesize callSite;
@synthesize reporter;
@synthesize subject;

#pragma mark - Ending Examples

- (void)exampleWillEnd {
    if (self.expectationType == KWExpectationTypeShould && self.subject == nil) {
        KWFailure *failure = [KWFailure failureWithCallSite:self.callSite message:@"expected subject not to be nil"];
        [self.reporter reportFailure:failure];
    } else if (self.expectationType == KWExpectationTypeShouldNot && self.subject != nil) {
        KWFailure *failure = [KWFailure failureWithCallSite:self.callSite format:@"expected subject to be nil, got %@",
                                                                                 [KWFormatter formatObject:self.subject]];
        [self.reporter reportFailure:failure];
    }
}

@end
