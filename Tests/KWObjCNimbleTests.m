#import <Kiwi/Kiwi.h>
#import <Nimble/Nimble.h>
#import "KWFailureInterceptingSpec.h"
#import "KiwiTestConfiguration.h"

CUSTOM_SPEC_BEGIN(KWObjCNimbleTests, KWFailureInterceptingSpec)

describe(@"Nimble matchers", ^{
    it(@"supports nmb_expect()", ^{
        [[theBlock(^{
            expect(@(1 + 1)).to(equal(@3));
        }) should] haveFailed];
    });
});

SPEC_END
