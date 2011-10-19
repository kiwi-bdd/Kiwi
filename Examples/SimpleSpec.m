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

SPEC_END

SPEC_BEGIN(HooksBehaviour)

describe(@"before hooks behaviour", ^{
  __block NSInteger calls = 0;
  
  beforeAll(^{
    calls++;
  });
  
  beforeEach(^{
    calls++;
  });
  
  it(@"will call beforeAll and beforeEach before this spec", ^{
    [[theValue(calls) should] equal:theValue(2)];
	});
  
  it(@"will call beforeEach but not beforeAll before this spec", ^{
    [[theValue(calls) should] equal:theValue(3)];
  });
  
  context(@"with nested contexts", ^{
    beforeAll(^{
      calls++;
    });
    
    beforeEach(^{
      calls++;
    });
    
    it(@"will call inner beforeAll and inner and outer beforeEach before this spec", ^{
      [[theValue(calls) should] equal:theValue(6)];
    });
    
    it(@"will call inner and outer beforeEach but neither beforeAll before this spec", ^{
      [[theValue(calls) should] equal:theValue(8)];
    });
    
    context(@"and another", ^{
      beforeAll(^{
        calls++;
      });
      
      beforeEach(^{
        calls++;
      });
      
      it(@"will call inner beforeAll and all inner and outer beforeEach hooks before this spec", ^{
        [[theValue(calls) should] equal:theValue(12)];
      });
      
      it(@"will call all inner and outer beforeEach but none of the beforeAll hooks before this spec", ^{
        [[theValue(calls) should] equal:theValue(15)];
      });
      
    });
    
    it(@"will call this after the nested context specs above", ^{
	    [[theValue(calls) should] equal:theValue(17)];
    });
  });
  
  it(@"will call this after both nested context specs above", ^{
    [[theValue(calls) should] equal:theValue(18)];
  });
});

SPEC_END

