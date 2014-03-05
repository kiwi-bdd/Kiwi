//
// Licensed under the terms in License.txt
//
// Copyright 2014 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "Cruiser.h"
#import "Carrier.h"

SPEC_BEGIN(KWSharedExampleFunctionalTest)

describe(@"Cruiser", ^{
    itBehavesLike(@"a cruiser", [Cruiser class]);
});

describe(@"Carrier", ^{
    itBehavesLike(@"a cruiser", [Carrier class]);
});

SPEC_END

SHARED_EXAMPLES_BEGIN(TestClasses)

sharedExamplesFor(@"a cruiser", ^(Class describedClass) {
    __block Cruiser *cruiser = nil;
    beforeEach(^{
        cruiser = [[describedClass alloc] initWithCallsign:@"Planet Express"];
    });

    it(@"has a callsign", ^{
        [[cruiser.callsign should] equal:@"Planet Express"];
    });
});

SHARED_EXAMPLES_END
