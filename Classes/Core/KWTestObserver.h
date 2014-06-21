//
//  KWTestObserver.h
//  Kiwi
//
//  Created by Ashton Williams on 3/05/2014.
//  Copyright (c) 2014 Allen Ding. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#ifdef XCT_EXPORT
@interface KWTestObserver : XCTestObserver
#else
@interface KWTestObserver : SenTestObserver
#endif

#ifdef XCT_EXPORT
- (void)testSuiteDidStart:(XCTestRun *)testRun;
- (void)testSuiteDidStop:(XCTestRun *)testRun;
- (void)testCaseDidStart:(XCTestRun *)testRun;
- (void)testCaseDidStop:(XCTestRun *)testRun;
- (void)testCaseDidFail:(XCTestRun *)testRun withDescription:(NSString *)description inFile:(NSString *)filePath atLine:(NSUInteger)lineNumber;
#else
+ (void)testSuiteDidStart:(NSNotification *)notification;
+ (void)testSuiteDidStop:(NSNotification *)notification;
+ (void)testCaseDidStart:(NSNotification *)notification;
+ (void)testCaseDidStop:(NSNotification *)notification;
+ (void)testCaseDidFail:(NSNotification *)notification;
#endif

@end
