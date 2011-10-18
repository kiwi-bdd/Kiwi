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

            it(@"has the first item", ^{
                [[arr should] contain:@"shark"];
            });

            it(@"has the second item", ^{
                [[arr should] contain:@"dolphin"];
            });

            specify(^{ [[arr should] haveCountOf:2]; });

            xit(@"has some funky behaviour", ^{});
        });
    });
});

describe(@"beforeAll", ^{
  __block NSInteger calls = 0;
  
  beforeAll(^{
    calls++;
  });
  
  it(@"will be called before this spec", ^{
    [[theValue(calls) should] equal:theValue(1)];
	});
  
  it(@"will not be called again before this spec", ^{
    [[theValue(calls) should] equal:theValue(1)];
  });
  
});

SPEC_END
