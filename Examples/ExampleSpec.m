//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiTestConfiguration.h"
#import "TestClasses.h"
#import "Kiwi.h"

/**
 * Due to the way the compiler works, in order to call dynamically created
 * methods (like our custom matchers) directly without using performSelector:,
 * the compiler needs to know that the method exists.
 *
 * We can encapsulate this requirement in a simple macro to forward-declare
 * our custom matchers.
 */

registerMatcher(haveFighters)


#if KW_TESTS_ENABLED

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

        defineMatcher(@"haveFighters", ^(KWUserDefinedMatcherBuilder *builder) {
            [builder match:^(id subject) {
                if (![subject isKindOfClass:[Cruiser class]]) {
                    return NO;
                }
                Cruiser *cruiser = subject;
                return cruiser.fighters.count > 0;
            }];
            [builder failureMessageForShould:^(id subject) {
                return [NSString stringWithFormat:@"%@ should have fighters", subject];
            }];
        });

        it(@"should have fighters (using custom matcher)", ^{
            [[cruiser should] haveFighters];
        });

        it(@"should work with @dynamic properties", ^{
            [[cruiser.classification should] equal:@"Capital Ship"];
        });

        it(@"should allow @dynamic properties to be stubbed with message pattern", ^{
            [[cruiser stubAndReturn:@"Galaxy Class Ship"] classification];
            [[cruiser.classification should] equal:@"Galaxy Class Ship"];
        });

        it(@"should allow @dynamic properties to be stubbed with API", ^{
            [cruiser stub:@selector(classification) andReturn:@"Galaxy Class Ship"];
            [[cruiser.classification should] equal:@"Galaxy Class Ship"];
        });
    });
});

SPEC_END

#endif // #if KW_TESTS_ENABLED
