#import "Kiwi.h"
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

SPEC_BEGIN(KWMessagePatternFunctionalTests)

describe(@"message patterns", ^{

    it(@"can match a selector with a specific single argument", ^{
        Cruiser *cruiser = [Cruiser cruiser];
        Fighter *fighter = [Fighter mock];
        [[cruiser should] receive:@selector(loadFighter:) withArguments:fighter];
        [cruiser loadFighter:fighter];
    });

});

SPEC_END
