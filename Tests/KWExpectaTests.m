#import <Kiwi/Kiwi.h>
#import <Expecta/Expecta.h>

SPEC_BEGIN(KWExpectaTests)

describe(@"expecta matchers", ^{
    it(@"supports expect()", ^{
        expect(1 + 1).to.equal(2);
    });
});

SPEC_END
