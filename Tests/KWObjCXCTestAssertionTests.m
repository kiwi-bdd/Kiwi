#import <Kiwi/Kiwi.h>

SPEC_BEGIN(KWObjCXCTestAssertionTests)

describe(@"XCTest assertions in Objective C", ^{
    pending(@"supports XCTAssert", ^{
        XCTAssert(1 + 1 == 2);
    });
});

SPEC_END
