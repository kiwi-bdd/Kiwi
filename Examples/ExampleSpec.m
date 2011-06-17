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

//[KWMatchers defineMatcher:@"beUppercaseString" as:^(KWMatcherBuilder *builder) {
//  [builder match:^(id subject) {
//    if ([subject isKindOfClass:[NSString class]]) {
//      NSString *string = (NSString *)subject;
//      return [[string uppercaseString] isEqualToString:string];
//    } else {
//      return NO;
//    }
//  }];
//}];
//
// [[@"SOME_STRING" should] beUppercaseString]

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
    });
});

SPEC_END

#endif // #if KW_TESTS_ENABLED && KW_BLOCKS_ENABLED
