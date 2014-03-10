//
//  KWSuiteConfigurationBase.h
//  Kiwi
//
//  Created by Adam Sharp on 14/12/2013.
//  Copyright (c) 2013 Allen Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KWSuiteConfigurationBase : NSObject

+ (instancetype)defaultConfiguration;

- (void)configureSuite;

- (void)setUp;
- (void)tearDown;

@property (nonatomic, copy) void (^beforeAllSpecsBlock)(void);
@property (nonatomic, copy) void (^afterAllSpecsBlock)(void);

#ifdef XCT_EXPORT
- (void)specDidStart:(XCTestRun *)testRun;
- (void)specDidStop:(XCTestRun *)testRun;

@property (nonatomic, copy) void (^beforeEachSpecBlock)(void);
@property (nonatomic, copy) void (^afterEachSpecBlock)(void);
#endif

@end

void beforeAllSpecs(void (^block)(void));
void afterAllSpecs(void (^block)(void));

#ifdef XCT_EXPORT
void beforeEachSpec(void (^block)(void));
void afterEachSpec(void (^block)(void));
#endif
