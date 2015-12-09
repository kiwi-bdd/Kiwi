#import <Kiwi/Kiwi.h>

SPEC_BEGIN(ExampleKiwiTests)

describe(@"maths", ^{
    it(@"is fun", ^{
        [[@(1 + 1) should] equal:@2];
    });
});

SPEC_END
