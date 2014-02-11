//
// Licensed under the terms in License.txt
//
// Copyright 2014 Allen Ding. All rights reserved.
//

#import "Kiwi.h"
#import "Cruiser.h"

#pragma mark - Custom Matcher Implementations

@interface HALTHyperdriveLevelMatcher : KWMatcher
@property (nonatomic, assign) NSInteger hyperdriveFuelLevel;
@end

@implementation HALTHyperdriveLevelMatcher

+ (NSArray *)matcherStrings {
    return @[@"haveHyperdriveFuelLevelGreaterThan:"];
}

- (BOOL)evaluate {
    return ((Cruiser *)self.subject).hyperdriveFuelLevel > self.hyperdriveFuelLevel;
}

- (void)haveHyperdriveFuelLevelGreaterThan:(NSInteger)hyperdriveFuelLevel {
    self.hyperdriveFuelLevel = hyperdriveFuelLevel;
}

@end

@interface FLOWCrewComplementMatcher : KWMatcher
@property (nonatomic, assign) NSInteger crewComplement;
@end

@implementation FLOWCrewComplementMatcher

+ (NSArray *)matcherStrings {
    return @[@"haveCrewComplementLessThan:"];
}

- (BOOL)evaluate {
    return ((Cruiser *)self.subject).crewComplement < self.crewComplement;
}

- (void)haveCrewComplementLessThan:(NSInteger)crewComplement {
    self.crewComplement = crewComplement;
}

@end

#pragma mark - Tests

SPEC_BEGIN(KWUserDefinedMatcherFunctionalTest)

registerMatchers(@"HALT");
registerMatchers(@"FLOW");

describe(@"Cruiser", ^{
    let(cruiser, ^id{ return [Cruiser new]; });

    it(@"has a hyperdrive fuel level above 50", ^{
        [[cruiser should] haveHyperdriveFuelLevelGreaterThan:50];
    });

    it(@"has a crew complement below 5000", ^{
        [[cruiser should] haveCrewComplementLessThan:5000];
    });
});

SPEC_END
