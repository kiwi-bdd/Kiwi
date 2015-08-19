#import <Kiwi/Kiwi.h>

SPEC_BEGIN(KWObjCXCTestAssertionTests)

describe(@"XCTest assertions in Objective C", ^{
    it(@"supports XCTAssert", ^{
        XCTAssert(1 + 1 == 2);
    });
});

SPEC_END
