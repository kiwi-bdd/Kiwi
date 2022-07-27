//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

// Used to suppress compiler warnings by
// casting receivers to this protocol
@protocol NSTask_KWWarningSuppressor

- (void)setLaunchPath:(NSString *)path;
- (void)setArguments:(NSArray *)arguments;
- (void)setEnvironment:(NSDictionary *)dict;
- (void)setStandardOutput:(id)output;
- (void)setStandardError:(id)output;
- (void)launch;
- (void)waitUntilExit;

@property (readonly) int terminationStatus;

@end

@interface KWBackgroundTask : NSObject

@property (nonatomic, readonly) id<NSTask_KWWarningSuppressor> task;
@property (nonatomic, readonly) NSPipe *standardOutput;
@property (nonatomic, readonly) NSPipe *standardError;
@property (nonatomic, readonly) NSString *command;
@property (nonatomic, readonly) NSArray *arguments;
@property (nonatomic, readonly) NSData *output;

- (instancetype)initWithCommand:(NSString *)command arguments:(NSArray *)arguments;

- (void)launchAndWaitForExit;

@end
