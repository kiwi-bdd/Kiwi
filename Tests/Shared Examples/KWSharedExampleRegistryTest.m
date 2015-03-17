//
// Licensed under the terms in License.txt
//
// Copyright 2014 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "KWSharedExampleRegistry.h"
#import "KWSharedExample.h"

@interface KWSharedExampleRegistryTest : XCTestCase

@end

@implementation KWSharedExampleRegistryTest

- (void)testRegisterSharedExample {
    KWSharedExample *sharedExample = [[KWSharedExample alloc] initWithName:@"LGTM"
                                                                     block:^(Class describedClass) {}];
    [[KWSharedExampleRegistry sharedRegistry] registerSharedExample:sharedExample];
    
    XCTAssertEqualObjects([[KWSharedExampleRegistry sharedRegistry] sharedExampleForName:@"LGTM"],
                          sharedExample,
                          @"Shared example was not registered.");
}

- (void)testRegisterSharedExampleWithSameNameRaises {
    KWSharedExample *firstSharedExample =
    [[KWSharedExample alloc] initWithName:@"ASAP"
                                    block:^(Class describedClass) {
                                        NSLog(@"This example will be registered.");
                                    }];
    KWSharedExample *secondSharedExample =
    [[KWSharedExample alloc] initWithName:@"ASAP"
                                    block:^(Class describedClass) {
                                        NSLog(@"This example will throw.");
                                    }];
    
    [[KWSharedExampleRegistry sharedRegistry] registerSharedExample:firstSharedExample];
    XCTAssertThrows([[KWSharedExampleRegistry sharedRegistry] registerSharedExample:secondSharedExample],
                    @"Registering shared example with identical name did not raise.");
}

- (void)testSharedExampleLookupRaisesIfNonexistent {
    XCTAssertThrows([[KWSharedExampleRegistry sharedRegistry] sharedExampleForName:@"XHTML"],
                    @"Lookup for unregistered shared example did not raise.");
}

@end
