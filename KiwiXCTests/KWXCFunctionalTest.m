//
//  KWXCFunctionalTest.m
//  KiwiXCTests
//
//  Created by Brian Ivan Gesiak on 9/13/13.
//  Copyright (c) 2013 Allen Ding. All rights reserved.
//

#import "Kiwi.h"

SPEC_BEGIN(XCFunctionalTest)

NSMutableArray *calls = [@[
    @"it",
    @"describe-beforeAll",
    @"describe-beforeEach",
    @"describe-afterEach",
    @"describe-afterAll",
    @"describe-it",
    @"describe-context-beforeAll",
    @"describe-context-beforeEach",
    @"describe-context-afterEach",
    @"describe-context-afterAll",
    @"describe-context-it"
] mutableCopy];

it(@"is a top-level it block", ^{
    [calls removeObject:@"it"];
    [[theValue([calls count]) should] equal:theValue(10)];
});

describe(@"within a describe block", ^{
    beforeAll(^{ [calls removeObject:@"describe-beforeAll"]; });
    beforeEach(^{ [calls removeObject:@"describe-beforeEach"]; });

    it(@"is a nested it block", ^{
        [calls removeObject:@"describe-it"];
        [[theValue([calls count]) should] equal:theValue(7)];
    });

    context(@"within a nested context block", ^{
        beforeAll(^{ [calls removeObject:@"describe-context-beforeAll"]; });
        beforeEach(^{ [calls removeObject:@"describe-context-beforeEach"]; });

        it(@"is a nested it block", ^{
            [calls removeObject:@"describe-context-it"];
            [[theValue([calls count]) should] equal:theValue(3)];
        });

        afterEach(^{ [calls removeObject:@"describe-context-afterEach"]; });
        afterAll(^{ [calls removeObject:@"describe-context-afterAll"]; });
    });

    afterEach(^{ [calls removeObject:@"describe-afterEach"]; });
    afterAll(^{
        [calls removeObject:@"describe-afterAll"];
        if ([calls count] > 0) {
            [NSException raise:NSInternalInconsistencyException
                        format:@"Not all XCFunctionalTest spec blocks were run."];
        }
    });
});

SPEC_END
