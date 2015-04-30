//
//  KWSymbolicator.m
//  Kiwi
//
//  Created by Jerry Marino on 4/28/13.
//  Copyright (c) 2013 Allen Ding. All rights reserved.
//

#import <objc/runtime.h>
#import <libunwind.h>
#import <pthread.h>
#import <mach-o/dyld.h>
#import "KWSymbolicator.h"

long kwCallerAddress (void){
#if !__arm__
	unw_cursor_t cursor; unw_context_t uc;
	unw_word_t ip;

	unw_getcontext(&uc);
	unw_init_local(&cursor, &uc);

    int pos = 2;
	while (unw_step(&cursor) && pos--){
		unw_get_reg (&cursor, UNW_REG_IP, &ip);
        if(pos == 0) return (NSUInteger)(ip - 4);
	}
#endif
    return 0;
}

NSString *const NSTaskDidTerminateNotification;

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

static NSString *const KWTaskDidTerminateNotification = @"KWTaskDidTerminateNotification";

@interface KWBackgroundTask : NSObject

@property (nonatomic, readonly) id<NSTask_KWWarningSuppressor> task;
@property (nonatomic, readonly) NSPipe *standardOutput;
@property (nonatomic, readonly) NSPipe *standardError;
@property (nonatomic, readonly) NSString *command;
@property (nonatomic, readonly) NSArray *arguments;
@property (nonatomic, readonly) NSData *output;

- (void)launchAndWaitForExit;

@end

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

@implementation KWCallSite (KWSymbolication)

static void GetTestBundleExecutablePathSlide(NSString **executablePath, long *slide) {
    for (int i = 0; i < _dyld_image_count(); i++) {
        if (strstr(_dyld_get_image_name(i), ".octest/") || strstr(_dyld_get_image_name(i), ".xctest/")) {
            *executablePath = [NSString stringWithUTF8String:_dyld_get_image_name(i)];
            *slide = _dyld_get_image_vmaddr_slide(i);
            break;
        }
    }
}

+ (KWCallSite *)callSiteWithCallerAddress:(long)address {
    // Symbolicate the address with atos to get the line number & filename.
    // If the command raises, no specs will run so don't bother catching
    // In the case of a non 0 exit code, failure to launch, or timeout, the
    // user will atleast have an idea of why the task failed.

    long slide;
    NSString *executablePath;
    GetTestBundleExecutablePathSlide(&executablePath, &slide);
    NSArray *arguments = @[@"-o", executablePath, @"-s", [NSString stringWithFormat:@"%lx", slide], [NSString stringWithFormat:@"%lx", address]];

    // See atos man page for more information on arguments.
    KWBackgroundTask *symbolicationTask = [[KWBackgroundTask alloc] initWithCommand:@"/usr/bin/atos" arguments:arguments];
    [symbolicationTask launchAndWaitForExit];

    NSString *symbolicatedCallerAddress = [[NSString alloc] initWithData:symbolicationTask.output encoding:NSUTF8StringEncoding];

    NSString *pattern = @".+\\((.+):([0-9]+)\\)";
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [regex matchesInString:symbolicatedCallerAddress options:0 range:NSMakeRange(0, symbolicatedCallerAddress.length)];

    NSString *fileName;
    NSInteger lineNumber = 0;

    for (NSTextCheckingResult *ntcr in matches) {
        fileName = [symbolicatedCallerAddress substringWithRange:[ntcr rangeAtIndex:1]];
        NSString *lineNumberMatch = [symbolicatedCallerAddress substringWithRange:[ntcr rangeAtIndex:2]];
        lineNumber = lineNumberMatch.integerValue;
    }
    return [KWCallSite callSiteWithFilename:fileName lineNumber:lineNumber];
}

@end
