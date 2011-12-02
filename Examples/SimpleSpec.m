//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"

@interface Card : NSObject



@end

@implementation Card


@end

SPEC_BEGIN(SimpleSpec)

describe(@"stack", ^{
    it(@"works", ^ {
        [[theValue(2) should] equal:theValue(3)];
    });
});

SPEC_END
