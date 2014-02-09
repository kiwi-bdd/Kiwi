//
// Licensed under the terms in License.txt
//
// Copyright 2014 Allen Ding. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "KWSharedExampleRegistry.h"
#import "KWSharedExample.h"

@interface KWSharedExampleRegistryTest : SenTestCase

@end

@implementation KWSharedExampleRegistryTest

- (void)testRegisterSharedExample {
    KWSharedExample *sharedExample = [[KWSharedExample alloc] initWithName:@"LGTM"
                                                                     block:^(Class describedClass) {}];
    [[KWSharedExampleRegistry sharedRegistry] registerSharedExample:sharedExample];

    STAssertEqualObjects([[KWSharedExampleRegistry sharedRegistry] sharedExampleForName:@"LGTM"],
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
    STAssertThrows([[KWSharedExampleRegistry sharedRegistry] registerSharedExample:secondSharedExample],
                   @"Registering shared example with identical name did not raise.");
}

- (void)testSharedExampleLookupRaisesIfNonexistent {
    STAssertThrows([[KWSharedExampleRegistry sharedRegistry] sharedExampleForName:@"XHTML"],
                   @"Lookup for unregistered shared example did not raise.");
}

@end
