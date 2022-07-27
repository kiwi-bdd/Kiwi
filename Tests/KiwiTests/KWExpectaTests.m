#import <Kiwi/Kiwi.h>
#import <Expecta/Expecta.h>
#import "KWFailureInterceptingSpec.h"
#import "KiwiTestConfiguration.h"

CUSTOM_SPEC_BEGIN(KWExpectaTests, KWFailureInterceptingSpec)

describe(@"alternate matcher support in Objective-C", ^{
    it(@"supports Expecta matchers", ^{
        [[theBlock(^{
            expect(1 + 1).to.equal(3);
        }) should] haveFailed];
    });
});

SPEC_END
