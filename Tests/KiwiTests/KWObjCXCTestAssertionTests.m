#import <Kiwi/Kiwi.h>
#import "KWFailureInterceptingSpec.h"
#import "KiwiTestConfiguration.h"

CUSTOM_SPEC_BEGIN(KWObjCXCTestAssertionTests, KWFailureInterceptingSpec)

describe(@"alternate matcher support in Objective-C", ^{
    it(@"supports XCTest assertions", ^{
        [[theBlock(^{
            XCTAssert(1 + 1 == 3);
        }) should] haveFailed];
    });
});

SPEC_END
