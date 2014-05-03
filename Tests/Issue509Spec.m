#import "Kiwi.h"
#import "KiwiTestConfiguration.h"

@interface TDD : NSObject
@property (getter = isDead) BOOL dead;
@end

@implementation TDD
- (NSUInteger)hash {
    // This implementation of `-hash` accesses a property, which may
    // or may not be stubbed. We are going to stub it later to demonstrate
    // that we don't get into an infinite loop when stubbing a method
    // that's used in an implementation of `-hash`.
    return self.isDead ? 0 : 1;
}
@end

SPEC_BEGIN(Issue509Spec)
it(@"won't enter an infinite loop", ^{
    TDD *tdd = [TDD new];
    [tdd stub:@selector(isDead) andReturn:theValue(NO)];
    [[theValue(tdd.isDead) should] beNo];
});
SPEC_END
