//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWFailure.h"
#import <SenTestingKit/SenTestingKit.h>
#import "KWCallSite.h"

@implementation KWFailure

#pragma mark -
#pragma mark Initializing

- (id)initWithCallSite:(KWCallSite *)aCallSite message:(NSString *)aMessage {
    if ((self = [super init])) {
        callSite = [aCallSite retain];
        message = [aMessage copy];
    }

    return self;
}

- (id)initWithCallSite:(KWCallSite *)aCallSite format:(NSString *)format, ... {
    va_list argumentList;
    va_start(argumentList, format);
    NSString *aMessage = [[[NSString alloc] initWithFormat:format arguments:argumentList] autorelease];
    return [self initWithCallSite:aCallSite message:aMessage];
}

+ (id)failureWithCallSite:(KWCallSite *)aCallSite message:(NSString *)aMessage {
    return [[[self alloc] initWithCallSite:aCallSite message:aMessage] autorelease];
}

+ (id)failureWithCallSite:(KWCallSite *)aCallSite format:(NSString *)format, ... {
    va_list argumentList;
    va_start(argumentList, format);
    NSString *message = [[[NSString alloc] initWithFormat:format arguments:argumentList] autorelease];
    return [self failureWithCallSite:aCallSite message:message];
}

- (void)dealloc {
    [callSite release];
    [message release];
    [super dealloc];
}

#pragma mark -
#pragma mark Properties

@synthesize message;
@synthesize callSite;

#pragma mark -
#pragma mark Getting Exception Representations

- (NSException *)exceptionValue {
    NSNumber *lineNumber = @(self.callSite.lineNumber);
    NSDictionary *userInfo = @{SenTestFilenameKey: self.callSite.filename,
                                                                        SenTestLineNumberKey: lineNumber};
    return [NSException exceptionWithName:@"KWFailureException" reason:message userInfo:userInfo];
}

@end
