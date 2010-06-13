//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWRaiseMatcher.h"
#import "KWFormatter.h"

@interface KWRaiseMatcher()

#pragma mark -
#pragma mark Properties

@property (nonatomic, readwrite) SEL selector;
@property (nonatomic, readwrite, retain) NSException *exception;
@property (nonatomic, readwrite, retain) NSException *actualException;

@end

@implementation KWRaiseMatcher

#pragma mark -
#pragma mark Initializing

- (void)dealloc {
    [exception release];
    [actualException release];
    [super dealloc];
}

#pragma mark -
#pragma mark Properties

@synthesize selector;
@synthesize exception;
@synthesize actualException;

#pragma mark -
#pragma mark Getting Matcher Strings

+ (NSArray *)matcherStrings {
    return [NSArray arrayWithObjects:@"raiseWhenSent:",
                                     @"raiseWithName:whenSent:",
                                     @"raiseWithReason:whenSent:",
                                     @"raiseWithName:reason:whenSent:", nil];
}

#pragma mark -
#pragma mark Matching

- (BOOL)evaluate {
    @try {
        [self.subject performSelector:self.selector];
    } @catch (NSException *anException) {
        self.actualException = anException;
        
        if ([self.exception name] != nil && ![[self.exception name] isEqualToString:[anException name]])
            return NO;
        
        if ([self.exception reason] != nil && ![[self.exception reason] isEqualToString:[anException reason]])
            return NO;
        
        return YES;
    }

    return NO;
}

#pragma mark -
#pragma mark Getting Failure Messages

+ (NSString *)exceptionPhraseWithException:(NSException *)anException {
    if (anException == nil)
        return @"nothing";

    NSString *namePhrase = nil;
    
    if ([anException name] == nil)
        namePhrase = @"exception";
    else
        namePhrase = [anException name];

    if ([anException reason] == nil)
        return namePhrase;
    
    return [NSString stringWithFormat:@"%@ \"%@\"", namePhrase, [anException reason]];
}

- (NSString *)failureMessageForShould {
    return [NSString stringWithFormat:@"expected %@, but %@ raised",
                                      [[self class] exceptionPhraseWithException:self.exception],
                                      [[self class] exceptionPhraseWithException:self.actualException]];
}

- (NSString *)failureMessageForShouldNot {
    return [NSString stringWithFormat:@"expected %@ not to be raised",
                                      [[self class] exceptionPhraseWithException:self.actualException]];
}

#pragma mark -
#pragma mark Configuring Matchers

- (void)raiseWhenSent:(SEL)aSelector {
    [self raiseWithName:nil reason:nil whenSent:aSelector];
}

- (void)raiseWithName:(NSString *)aName whenSent:(SEL)aSelector {
    [self raiseWithName:aName reason:nil whenSent:aSelector];
}

- (void)raiseWithReason:(NSString *)aReason whenSent:(SEL)aSelector {
    [self raiseWithName:nil reason:aReason whenSent:aSelector];
}

- (void)raiseWithName:(NSString *)aName reason:(NSString *)aReason whenSent:(SEL)aSelector {
    self.selector = aSelector;
    self.exception = [NSException exceptionWithName:aName reason:aReason userInfo:nil];
}

@end
