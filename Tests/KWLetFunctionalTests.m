#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

SPEC_BEGIN(KWLetFunctionalTests)

describe(@"Greeting", ^{
    let(subject, ^{ return @""; });
    let(greeting, ^{ return [NSString stringWithFormat:@"Hello, %@!", subject]; });

    describe(@"default subject", ^{
        specify(^{ [[subject should] beEmpty]; });
    });

    context(@"with the subject \"world\"", ^{
        let(subject, ^{ return @"world"; });

        specify(^{ [[greeting should] equal:@"Hello, world!"]; });
    });

    context(@"with the subject \"Kiwi\"", ^{
        let(subject, ^{ return @"Kiwi"; });

        specify(^{ [[greeting should] equal:@"Hello, Kiwi!"]; });
    });
});

describe(@"Let context tree", ^{
    let(number, ^{ return @0; });
    let(string, ^{ return [number stringValue]; });

    describe(@"number 1", ^{
        let(number, ^{ return @1; });

        context(@"number 2", ^{
            let(number, ^{ return @2; });

            context(@"number 3", ^{
                let(number, ^{ return @3; });

                context(@"number 4", ^{
                    let(number, ^{ return @4; });

                    specify(^{ [[number should] equal:@4]; });
                    specify(^{ [[string should] equal:@"4"]; });
                });

                specify(^{ [[number should] equal:@3]; });
                specify(^{ [[string should] equal:@"3"]; });
            });

            specify(^{ [[number should] equal:@2];});
            specify(^{ [[string should] equal:@"2"]; });
        });

        context(@"number 5", ^{
            let(number, ^{ return @5; });

            context(@"number 6", ^{
                let(number, ^{ return @6; });

                specify(^{ [[number should] equal:@6]; });
                specify(^{ [[string should] equal:@"6"]; });
            });

            specify(^{ [[number should] equal:@5]; });
            specify(^{ [[string should] equal:@"5"]; });
        });

        specify(^{ [[number should] equal:@1]; });
        specify(^{ [[string should] equal:@"1"]; });
    });
});

describe(@"using property notation", ^{
    let(cruiser, ^{ return [[Cruiser alloc] initWithCallsign:@"let"]; });
    specify(^{
        [[cruiser.callsign should] equal:@"let"];
    });
});

describe(@"a let node set up in an outer context with a beforeEach block", ^{

    let(number, ^{ return @123; });
    let(array,  ^{ return [NSMutableArray array]; });

    beforeEach(^{
        [array addObject:number];
    });

    context(@"when referenced in an inner context with a beforeEach block", ^{
        beforeEach(^{
            [array addObject:@456];
        });

        it(@"retains state from the outer context", ^{
            [[array should] equal:@[ @123, @456 ]];
        });
    });

});

SPEC_END
