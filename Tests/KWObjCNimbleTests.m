#import <Kiwi/Kiwi.h>
#import <Nimble/Nimble.h>

SPEC_BEGIN(KWObjCNimbleTests)

describe(@"Nimble matchers", ^{
    it(@"supports nmb_expect()", ^{
        expect(@(1 + 1)).to(equal(@2));
    });
});

SPEC_END
