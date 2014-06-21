//
//  KWTestObserver.m
//  Kiwi
//
//  Created by Ashton Williams on 3/05/2014.
//  Copyright (c) 2014 Allen Ding. All rights reserved.
//

#import "KWTestObserver.h"

NSString * const SenTestObserverClassKey = @"KWTestObserver";
NSString * const XCTestObserverClassKey = @"KWTestObserver";

#define XCODE_COLORS_ESCAPE    @"\033["
#define XCODE_COLORS_RESET_FG  XCODE_COLORS_ESCAPE @"fg;" // Clear any foreground color
#define XCODE_COLORS_RESET_BG  XCODE_COLORS_ESCAPE @"bg;" // Clear any background color
#define XCODE_COLORS_RESET     XCODE_COLORS_ESCAPE @";"   // Clear any foreground or background color

NSString * const kKWtestSuiteDidStartColor = XCODE_COLORS_ESCAPE @"fg0,0,128;";
NSString * const kKWtestSuiteSuccessColor  = XCODE_COLORS_ESCAPE @"fg0,128,0;";
NSString * const kKWtestSuiteFailureColor  = XCODE_COLORS_ESCAPE @"fg128,0,0;";

NSString * const kKWtestCaseDidStartColor  = XCODE_COLORS_ESCAPE @"fg0,0,128;";
NSString * const kKWtestCaseSuccessColor   = XCODE_COLORS_ESCAPE @"fg0,128,0;";
NSString * const kKWtestCaseFailureColor   = XCODE_COLORS_ESCAPE @"fg128,0,0;";
NSString * const kKWtestCaseDidFailColor   = XCODE_COLORS_ESCAPE @"fg128,0,128;";

@implementation KWTestObserver

+ (void)initialize {
    char *xcode_colors = getenv("XcodeColors");
    if (xcode_colors && (strcmp(xcode_colors, "YES") == 0))
    {
        [[NSUserDefaults standardUserDefaults] setValue:SenTestObserverClassKey forKey:@"SenTestObserverClass"];
        [[NSUserDefaults standardUserDefaults] setValue:XCTestObserverClassKey forKey:@"XCTestObserverClass"];
        // http://stackoverflow.com/a/6149887/1748787 Johannes Rudolph
        // we need to force SenTestObserver to register us as a handler
        // SenTestObserver is properly guarding against this invocation so nothing bad will hapen
        // but this is required (bad design on SenTestObserver's side)...
    }
    else {
        if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"SenTestObserverClass"] isEqualToString:SenTestObserverClassKey]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SenTestObserverClass"];
        }
        if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"XCTestObserverClass"] isEqualToString:XCTestObserverClassKey]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"XCTestObserverClass"];
        }
    }
    [super initialize];
}

#pragma mark - XcodeColors

static void beginColor(NSString *colorString)
{
	testLog(colorString);
}

static void endColor()
{
	testLog(XCODE_COLORS_RESET);
}

static void testLog(NSString *message)
{
	NSString *line = [NSString stringWithFormat:@"%@", message];
	[(NSFileHandle *)[NSFileHandle fileHandleWithStandardOutput] writeData:[line dataUsingEncoding:NSUTF8StringEncoding]];
}

#ifdef XCT_EXPORT

#pragma mark - XCTestObserver

- (void)testSuiteDidStart:(XCTestRun *)testRun {
    beginColor(kKWtestSuiteDidStartColor);
    [super testSuiteDidStart:testRun];
    endColor();
}

- (void)testSuiteDidStop:(XCTestRun *)testRun {
	if (testRun.hasSucceeded) {
		beginColor(kKWtestSuiteSuccessColor);
	}
	else {
		beginColor(kKWtestSuiteFailureColor);
	}
    [super testSuiteDidStop:testRun];
    endColor();
}

- (void)testCaseDidStart:(XCTestRun *)testRun {
    beginColor(kKWtestCaseDidStartColor);
    [super testCaseDidStart:testRun];
    endColor();
}

- (void)testCaseDidStop:(XCTestRun *)testRun {
    if (testRun.hasSucceeded) {
		beginColor(kKWtestCaseSuccessColor);
	}
	else {
		beginColor(kKWtestCaseFailureColor);
	}
    [super testCaseDidStop:testRun];
    endColor();
}

- (void)testCaseDidFail:(XCTestRun *)testRun
        withDescription:(NSString *)description
                 inFile:(NSString *)filePath
                 atLine:(NSUInteger)lineNumber {
    beginColor(kKWtestCaseDidFailColor);
    [super testCaseDidFail:testRun
           withDescription:description
                    inFile:filePath
                    atLine:lineNumber];
    endColor();
    
}

#else

#pragma mark - SenTestObserver

+ (void)testSuiteDidStart:(NSNotification *)notification {
    beginColor(kKWtestSuiteDidStartColor);
    [SenTestLog testSuiteDidStart:notification];
    endColor();
}

+ (void)testSuiteDidStop:(NSNotification *)notification {
	if (notification.run.hasSucceeded) {
		beginColor(kKWtestSuiteSuccessColor);
	}
	else {
		beginColor(kKWtestSuiteFailureColor);
	}
    [SenTestLog testSuiteDidStop:notification];
    endColor();
}

+ (void)testCaseDidStart:(NSNotification *)notification {
    beginColor(kKWtestCaseDidStartColor);
    [SenTestLog testCaseDidStart:notification];
    endColor();
}

+ (void)testCaseDidStop:(NSNotification *)notification {
    if (notification.run.hasSucceeded) {
		beginColor(kKWtestCaseSuccessColor);
	}
	else {
		beginColor(kKWtestCaseFailureColor);
	}
    [SenTestLog testCaseDidStop:notification];
    endColor();
}

+ (void)testCaseDidFail:(NSNotification *)notification {
    beginColor(kKWtestCaseDidFailColor);
    [SenTestLog testCaseDidFail:notification];
    endColor();
}

#endif

@end
