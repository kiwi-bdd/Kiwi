//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "Kiwi.h"

@interface ABCDummyMatcher : KWMatcher
- (void)justWork;
@end

@implementation ABCDummyMatcher

+ (NSArray *)matcherStrings {
  return [NSArray arrayWithObject:@"justWork"];
}

- (void)justWork {};

- (BOOL)evaluate
{
  return YES;
}

@end

SPEC_BEGIN(SimpleSpec)

describe(@"anything", ^{
  
  it(@"allows matchers to be registered after the first spec", ^{
    [[@"this" should] equal:@"this"];
  });
  
  registerMatchers(@"ABC");
  
  it(@"can work with a custom registered matcher", ^{
    [[@"anything" should] justWork];
  });
  
});

describe(@"stack", ^{
    __block NSMutableArray *arr = nil;

    context(@"new", ^{
        beforeEach(^{
            arr = [NSMutableArray array];
            [arr addObject:@"shark"];
        });

        context(@"with 2 items", ^{
            beforeEach(^{
                [arr addObject:@"dolphin"];
            });

            it(@"has the first item", ^{
                [[arr should] contain:@"shark"];
            });

            it(@"has the second item", ^{
                [[arr should] contain:@"dolphin"];
            });

            specify(^{ [[arr should] haveCountOf:2]; });

            xit(@"has some funky behaviour", ^{});
        });
    });
});

SPEC_END


