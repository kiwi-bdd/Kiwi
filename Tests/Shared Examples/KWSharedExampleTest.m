//
// Licensed under the terms in License.txt
//
// Copyright 2014 Allen Ding. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "KiwiTestConfiguration.h"
#import "KWSharedExample.h"
#import "KWSharedExampleRegistry.h"
#import "KWExample.h"

@interface KWSharedExampleTest : XCTestCase

@end

@implementation KWSharedExampleTest

- (void)testSharedExampleMustHaveNameParameter {
    XCTAssertThrows([[KWSharedExample alloc] initWithName:nil block:nil],
                    @"Unnamed shared example was created");
}

- (void)testSharedExampleMustHaveBlockParameter {
    XCTAssertThrows([[KWSharedExample alloc] initWithName:@"FTW"
                                                    block:nil],
                    @"Shared example was created without a corresponding context block");
}

- (void)testSharedExamplesForRegistersTheSharedExample {
    sharedExamplesFor(@"FTTP", ^(Class sharedExample) {});
    XCTAssertEqualObjects([[KWSharedExampleRegistry sharedRegistry] sharedExampleForName:@"FTTP"].name,
                          @"FTTP",
                          @"Shared example was not registered.");
}

- (void)testItBehavesLikeExecutesTheBlock {
    __block NSNumber *blockWasCalled = @NO;
    sharedExamplesFor(@"ESP", ^(NSDictionary *data) {
        beforeAll(^{
            blockWasCalled = @YES;
        });
        context(@"with LSD", ^{
            blockWasCalled = @YES;
        });
    });
    
    XCTAssertFalse([blockWasCalled boolValue],
                   @"Blocks in shared example were executed prematurely.");
}

@end
