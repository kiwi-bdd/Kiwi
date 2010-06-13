//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWBlockRaiseMatcher.h"
#import "KWBlock.h"

#if KW_BLOCKS_ENABLED

@interface KWBlockRaiseMatcher()

#pragma mark -
#pragma mark Properties

@property (nonatomic, readwrite, retain) NSException *exception;
@property (nonatomic, readwrite, retain) NSException *actualException;

@end

@implementation KWBlockRaiseMatcher

#pragma mark -
#pragma mark Initializing

- (void)dealloc {
    [exception release];
    [actualException release];
    [super dealloc];
}

#pragma mark -
#pragma mark Properties

@synthesize exception;
@synthesize actualException;

#pragma mark -
#pragma mark Getting Matcher Strings

+ (NSArray *)matcherStrings {
    return [NSArray arrayWithObjects:@"raise",
                                     @"raiseWithName:",
                                     @"raiseWithReason:",
                                     @"raiseWithName:reason:", nil];
}

#pragma mark -
#pragma mark Matching

- (BOOL)evaluate {
    if (![self.subject isKindOfClass:[KWBlock class]])
        [NSException raise:@"KWMatcherException" format:@"subject must be a KWBlock"];
    
    @try {
        [self.subject call];
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

- (void)raise {
    [self raiseWithName:nil reason:nil];
}

- (void)raiseWithName:(NSString *)aName {
    [self raiseWithName:aName reason:nil];
}

- (void)raiseWithReason:(NSString *)aReason {
    [self raiseWithName:nil reason:aReason];
}

- (void)raiseWithName:(NSString *)aName reason:(NSString *)aReason {
    self.exception = [NSException exceptionWithName:aName reason:aReason userInfo:nil];
}

@end

#endif // #if KW_BLOCKS_ENABLED
