//
//  TestSuiteConfigurationAdditions.h
//  Kiwi
//
//  Created by Adam Sharp on 17/12/2013.
//  Copyright (c) 2013 Allen Ding. All rights reserved.
//

#ifdef XCT_EXPORT
@interface XCTestSuite (SuiteConfigurationAdditions)
#else
@interface SenTestSuite (SuiteConfigurationAdditions)
#endif

@end
