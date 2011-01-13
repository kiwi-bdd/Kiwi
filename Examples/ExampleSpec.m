//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiTestConfiguration.h"
#import "TestClasses.h"
#import "Kiwi.h"

#if KW_TESTS_ENABLED && KW_BLOCKS_ENABLED

SPEC_BEGIN(ExampleSpec)

describe(@"Cruiser", ^{
    registerMatchers(@"KWT");
    
    context(@"with fighters set", ^{
        __block Cruiser *cruiser = nil;
        
        beforeAll(^{
        });
        
        afterAll(^{
        });
        
        beforeEach(^{
            cruiser = [Cruiser cruiser];
            [cruiser stub:@selector(raiseShields) andReturn:theValue(NO)];
            [cruiser setFighters:[NSArray arrayWithObjects:[Fighter fighterWithCallsign:@"Viper 1"],
                                                           [Fighter fighterWithCallsign:@"Viper 2"],
                                                           [Fighter fighterWithCallsign:@"Viper 3"], nil]];
        });
        
        pending(@"should be really big", nil);
        
        it(@"should have fighters", ^{
            [[[cruiser should] have:3] fighters];
            [[cruiser.fighters shouldNot] beEmpty];
            [Cruiser stub:@selector(classification) andReturn:@"Animal"];
        });
        
        it(@"should raise shields", ^{
            [[[Cruiser classification] should] equal:@"Capital Ship"];
            [[theValue([cruiser raiseShields]) should] beFalse];
            [[cruiser should] receive:@selector(fighterWithCallsign:)];
            [cruiser fighterWithCallsign:@"Apollo"];
        });
        
        it(@"should raise if asked", ^{
            [[[Cruiser classification] should] equal:@"Capital Ship"];
            [[lambda(^{
                [cruiser raiseWithName:@"FooException" description:@"Foo"];
            }) should] raiseWithName:@"FooException"];
        });
		
		const float nanosecondToSeconds = 1e9;
		
		it(@"should verify asynchronous expectations that succeed in time", ^{
			__block NSString *fetchedData = nil;
			
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * nanosecondToSeconds), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
				fetchedData = @"expected response data";
			});

			// this will block until the matcher is satisfied or it times out (default: 1s)
			[[theObject(&fetchedData) shouldEventually] equal:@"expected response data"];
		});
		
		it(@"should verify asynchronous expectations that succeed with an explicit time", ^{
			__block NSString *fetchedData = nil;
						
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * nanosecondToSeconds), dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
				fetchedData = @"expected response data";
			});
			
			// this will block until the matcher is satisfied or it times out (default: 1s)
			[[theObject(&fetchedData) shouldEventuallyBeforeTimingOutAfter(2.0)] equal:@"expected response data"];
		});
    });
});

SPEC_END

#endif // #if KW_TESTS_ENABLED && KW_BLOCKS_ENABLED
