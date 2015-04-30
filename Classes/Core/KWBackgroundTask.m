//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWBackgroundTask.h"

NSString *const NSTaskDidTerminateNotification;

static NSString *const KWTaskDidTerminateNotification = @"KWTaskDidTerminateNotification";

static NSString *const KWBackgroundTaskException = @"KWBackgroundTaskException";

@implementation KWBackgroundTask

- (instancetype)initWithCommand:(NSString *)command arguments:(NSArray *)arguments {
    if (self = [super init]) {
        _command = command;
        _arguments = arguments;
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSTaskDidTerminateNotification object:nil];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@ `%@ %@`", [super description], self.command, [self.arguments componentsJoinedByString:@" "]];
}

// Run this task for 10 seconds
// if it times out raise an exception
- (void)launchAndWaitForExit {
    CFRunLoopRef runLoop = [NSRunLoop currentRunLoop].getCFRunLoop;
    __weak KWBackgroundTask *weakSelf = self;
    CFRunLoopTimerRef timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent() + 10.0, 0, 0, 0, ^(CFRunLoopTimerRef timer) {
        [NSException raise:KWBackgroundTaskException format:@"Task %@ timed out", weakSelf];
        CFRunLoopStop(runLoop);
    });
    CFRunLoopAddTimer(runLoop, timer, kCFRunLoopDefaultMode);

    id taskObserver = [[NSNotificationCenter defaultCenter] addObserverForName:KWTaskDidTerminateNotification object:self queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        CFRunLoopStop(runLoop);
    }];

    [NSThread detachNewThreadSelector:@selector(launch) toTarget:self withObject:nil];
    CFRunLoopRun();
    CFRunLoopRemoveTimer(runLoop, timer, kCFRunLoopDefaultMode);

    [[NSNotificationCenter defaultCenter] removeObserver:taskObserver];
}

#pragma mark - Private

- (void)launch {
    __block id<NSTask_KWWarningSuppressor> task = [[NSClassFromString(@"NSTask") alloc] init];
    [task setEnvironment:[NSDictionary dictionary]];
    [task setLaunchPath:_command];
    [task setArguments:_arguments];

    NSPipe *standardOutput = [NSPipe pipe];
    [task setStandardOutput:standardOutput];

    // Consume standard error but don't use it
    NSPipe *standardError = [NSPipe pipe];
    [task setStandardError:standardError];

    _task = task;
    _standardError = standardError;
    _standardOutput = standardOutput;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(taskDidTerminate:) name:NSTaskDidTerminateNotification object:task];

    @try {
        [_task launch];
    } @catch (NSException *exception) {
        [NSException raise:KWBackgroundTaskException format:@"Task %@ failed to launch", self];
    }
    CFRunLoopRun();
}

- (void)taskDidTerminate:(NSNotification *)note {
    if ([_task terminationStatus] != 0) {
        [NSException raise:KWBackgroundTaskException format:@"Task %@ terminated with non 0 exit code", self];
    } else {
        _output = [[_standardOutput fileHandleForReading] readDataToEndOfFile];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:KWTaskDidTerminateNotification object:self];
    [NSThread exit];
}

@end
