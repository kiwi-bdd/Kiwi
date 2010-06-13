//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"

@class KWCallSite;

@interface KWFailure : NSObject {
@private
    KWCallSite *callSite;
    NSString *message;
}

#pragma mark -
#pragma mark Initializing

- (id)initWithCallSite:(KWCallSite *)aCallSite message:(NSString *)aMessage;
- (id)initWithCallSite:(KWCallSite *)aCallSite format:(NSString *)format, ...;

+ (id)failureWithCallSite:(KWCallSite *)aCallSite message:(NSString *)aMessage;
+ (id)failureWithCallSite:(KWCallSite *)aCallSite format:(NSString *)format, ...;

#pragma mark -
#pragma mark Properties

@property (nonatomic, readonly) NSString *message;
@property (nonatomic, readonly) KWCallSite *callSite;

#pragma mark -
#pragma mark Getting Exception Representations

- (NSException *)exceptionValue;

@end
