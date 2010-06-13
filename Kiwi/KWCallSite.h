//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"

@interface KWCallSite : NSObject {
@private
    NSString *filename;
    NSUInteger lineNumber;
}

#pragma mark -
#pragma mark Initializing

- (id)initWithFilename:(NSString *)aFilename lineNumber:(NSUInteger)aLineNumber;

+ (id)callSiteWithFilename:(NSString *)aFilename lineNumber:(NSUInteger)aLineNumber;

#pragma mark -
#pragma mark Properties

@property (nonatomic, readonly, copy) NSString *filename;
@property (nonatomic, readonly) NSUInteger lineNumber;

#pragma mark -
#pragma mark Identifying and Comparing

- (BOOL)isEqualToCallSite:(KWCallSite *)aCallSite;

@end
