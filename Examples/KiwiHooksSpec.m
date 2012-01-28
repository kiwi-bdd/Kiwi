//
//  KiwiHooksSpec.m
//  Kiwi
//
//  Created by Luke Redpath on 19/10/2011.
//  Copyright 2011 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "KiwiTestConfiguration.h"

SPEC_BEGIN(BeforeHooksBehaviour)

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

SPEC_BEGIN(AfterHooksBehaviour)

describe(@"after hooks behaviour", ^{
  __block NSInteger calls = 0;
  
  afterAll(^{
    NSLog(@"FINAL AFTER ALL. Can't test this as it's the last thing to run, but verify with log output");
  });
  
  afterEach(^{
    calls++;
  });
  
  it(@"will call afterEach but not afterAll after this spec", ^{
    [[theValue(calls) should] equal:theValue(0)];
	});
  
  it(@"will call afterEach but not afterAll after this spec", ^{
    [[theValue(calls) should] equal:theValue(1)];
  });
  
  context(@"with nested contexts", ^{
    afterAll(^{
      NSLog(@"[with nested contexts] afterAll");
      calls++;
    });
    
    afterEach(^{
      calls++;
    });
    
    it(@"will call inner afterEach and outer afterEach but not afterAll after this spec", ^{
      [[theValue(calls) should] equal:theValue(2)];
    });
    
    it(@"will call inner afterEach and outer afterEach but not afterAll after this spec", ^{
      [[theValue(calls) should] equal:theValue(4)];
    });
    
    context(@"and another", ^{
      afterAll(^{
        NSLog(@"[with nested contexts and another] afterAll");
        calls++;
      });
      
      afterEach(^{
        calls++;
      });
      
      it(@"will call inner afterEach and each outer afterEach but not afterAll after this spec", ^{
        [[theValue(calls) should] equal:theValue(6)];
      });
      
      it(@"will call inner afterEach and each outer afterEach and the inner afterAll after this spec", ^{
        [[theValue(calls) should] equal:theValue(9)];
      });      
    });
    
    it(@"will call this after the nested context specs above, reflecting the result of its afterAll, and this context's afterAll after this spec", ^{
	    [[theValue(calls) should] equal:theValue(13)];
    });
  });
  
  it(@"will call this after both nested context specs above", ^{
    [[theValue(calls) should] equal:theValue(16)];
  });
});

SPEC_END
