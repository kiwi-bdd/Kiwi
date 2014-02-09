//
// Licensed under the terms in License.txt
//
// Copyright 2014 Allen Ding. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "KWSharedExample.h"
#import "KWSharedExampleRegistry.h"
#import "KWExample.h"

@interface KWSharedExampleTest : SenTestCase

@end

@implementation KWSharedExampleTest

- (void)testSharedExampleMustHaveNameParameter {
    STAssertThrows([[KWSharedExample alloc] initWithName:nil block:nil],
                   @"Unnamed shared example was created");
}

- (void)testSharedExampleMustHaveBlockParameter {
    STAssertThrows([[KWSharedExample alloc] initWithName:@"FTW"
                                                   block:nil],
                   @"Shared example was created without a corresponding context block");
}

- (void)testSharedExamplesForRegistersTheSharedExample {
    sharedExamplesFor(@"FTTP", ^(Class sharedExample) {});
    STAssertEqualObjects([[KWSharedExampleRegistry sharedRegistry] sharedExampleForName:@"FTTP"].name,
                         @"FTTP",
                         @"Shared example was not registered.");
}

- (void)testItBehavesLikeExecutesTheBlock {
    __block NSNumber *blockWasCalled = @NO;
    sharedExamplesFor(@"ESP", ^(Class describedClass) {
        beforeAll(^{
            blockWasCalled = @YES;
        });
        context(@"with LSD", ^{
            blockWasCalled = @YES;
        });
    });

    STAssertFalse([blockWasCalled boolValue],
                  @"Blocks in shared example were executed prematurely.");
}

@end
