//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWContainMatcher.h"
#import "KWFormatter.h"
#import "KWHamrestMatchingAdditions.h"

@interface KWContainMatcher()

#pragma mark -
#pragma mark Properties

@property (nonatomic, readwrite, retain) id objects;

@end

@implementation KWContainMatcher

#pragma mark -
#pragma mark Initializing

- (void)dealloc {
    [objects release];
    [super dealloc];
}

#pragma mark -
#pragma mark Properties

@synthesize objects;

#pragma mark -
#pragma mark Getting Matcher Strings

+ (NSArray *)matcherStrings {
    return [NSArray arrayWithObjects:@"contain:", @"containObjectsInArray:", nil];
}

#pragma mark -
#pragma mark Matching

- (BOOL)evaluate {
    if (![self.subject respondsToSelector:@selector(containsObjectEqualToOrMatching:)])
        [NSException raise:@"KWMatcherException" format:@"subject does not respond to -containsObjectEqualToOrMatching:"];
    
    for (id object in self.objects) {
        if (![self.subject containsObjectEqualToOrMatching:object])
          return NO;
    }
    
    return YES;
}

#pragma mark -
#pragma mark Getting Failure Messages

- (NSString *)objectsPhrase {
    if ([self.objects count] == 1)
        return [KWFormatter formatObject:[self.objects objectAtIndex:0]];

    return [KWFormatter formatObject:self.objects];
}

- (NSString *)failureMessageForShould {
    return [NSString stringWithFormat:@"expected subject to contain %@", [self objectsPhrase]];
}

#pragma mark -
#pragma mark Configuring Matchers

- (void)contain:(id)anObject {
    self.objects = [NSArray arrayWithObject:anObject];
}

- (void)containObjectsInArray:(NSArray *)anArray {
    self.objects = anArray;
}

@end

@implementation KWMatchVerifier(KWContainMatcherAdditions)

#pragma mark -
#pragma mark Verifying

- (void)containObjects:(id)firstObject, ... {
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    
    va_list argumentList;
    va_start(argumentList, firstObject);
    id object = firstObject;
    
    while (object != nil) {
        [objects addObject:object];
        object = va_arg(argumentList, id);
    }
    
    va_end(argumentList);
    [(id)self containObjectsInArray:objects];
}

@end
