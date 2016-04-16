#import <Kiwi/Kiwi.h>
#import "KiwiTestConfiguration.h"
#import "TestClasses.h"

typedef void(^KWVoidTestBlock)();
typedef void(^KWArgumentTestBlock)(id);
typedef void(^KWMultiArgumentTestBlock)(id, id, id);

SPEC_BEGIN(KWMessagePatternFunctionalTests)

describe(@"message patterns", ^{
    NSString *description = @"description";
    NSString *format = nil;

    Cruiser *cruiser = [Cruiser new];
    
    it(@"can match a selector with no arguments", ^{
        [[cruiser should] receive:@selector(computeParsecs)];
        
        [cruiser computeParsecs];
    });
    
    it(@"can match a selector with a specific single argument", ^{
        Fighter *fighter = [Fighter mock];
        
        [[cruiser should] receive:@selector(loadFighter:) withArguments:fighter];
        
        [cruiser loadFighter:fighter];
    });
    
    it(@"can match a selector with specific multiple arguments", ^{
        [[cruiser should] receive:@selector(raiseWithName:description:) withArguments:description, format];
        
        [cruiser raiseWithName:description description:format];
    });

    it(@"can match a selector with multiple arguments", ^{
        [[cruiser should] receive:@selector(raiseWithName:description:)];
        
        [cruiser raiseWithName:description description:format];
    });
});

describe(@"block message patterns", ^{
    id argument1 = [NSObject new];
    id argument2 = [NSObject new];
    
    it(@"can match a call with a call without arguments", ^{
        id block = theBlockProxy(^{ });
        
        [[block should] beEvaluated];
        
        ((KWVoidTestBlock)block)();
    });
    
    it(@"can match a call with a specific single argument", ^{
        id block = theBlockProxy(^(id object) { });
        
        [[block should] beEvaluatedWithArguments:argument1];

        ((KWArgumentTestBlock)block)(argument1);
    });
    
    it(@"can match a call with specific multiple arguments", ^{
        id block = theBlockProxy(^(id object1, id object2, id object3) { });
        
        [[block should] beEvaluatedWithArguments:argument1, nil, argument2];
        
        ((KWMultiArgumentTestBlock)block)(argument1, nil, argument2);
    });
    
    it(@"can match a call with multiple arguments", ^{
        id block = theBlockProxy(^(id object1, id object2, id object3) { });
        
        [[block should] beEvaluated];
        
        ((KWMultiArgumentTestBlock)block)(argument1, nil, argument2);
    });
});

SPEC_END
