//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"

SPEC_BEGIN(SimpleSpec)

describe(@"stack", ^{
    __block NSMutableArray *arr = nil;
    
    context(@"new", ^{
        beforeEach(^{
            arr = [NSMutableArray array];
            [arr addObject:@"shark"];
        });
        
        context(@"with 2 items", ^{
            beforeEach(^{
                [arr addObject:@"dolphin"];
            });
            
            it(@"has 2 items", ^{
                [[arr should] contain:@"dolphin"];
                arr = nil;
            });
            
            it(@"has 2 items", ^{
                [[arr should] contain:@"dolphin"];
                arr = nil;
            });
        });
    });
});

SPEC_END
