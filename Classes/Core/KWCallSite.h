//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"

@interface KWCallSite : NSObject

@property (nonatomic, readonly, copy) NSString *path;
@property (nonatomic, readonly) NSString *fileName;
@property (nonatomic, readonly) NSUInteger lineNumber;

- (instancetype)initWithPath:(NSString *)path lineNumber:(NSUInteger)lineNumber;
- (instancetype)initWithFileName:(NSString *)fileName lineNumber:(NSUInteger)lineNumber;
    
+ (instancetype)callSiteWithPath:(NSString *)path lineNumber:(NSUInteger)lineNumber;
+ (instancetype)callSiteWithFileName:(NSString *)fileName lineNumber:(NSUInteger)lineNumber;

- (BOOL)isEqualToCallSite:(KWCallSite *)aCallSite;

@end
