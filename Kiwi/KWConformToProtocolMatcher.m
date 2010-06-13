//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWConformToProtocolMatcher.h"
#import "KWFormatter.h"

@interface KWConformToProtocolMatcher()

#pragma mark -
#pragma mark Properties

@property (nonatomic, readwrite, assign) Protocol *protocol;

@end

@implementation KWConformToProtocolMatcher

#pragma mark -
#pragma mark Properties

@synthesize protocol;

#pragma mark -
#pragma mark Getting Matcher Strings

+ (NSArray *)matcherStrings {
    return [NSArray arrayWithObject:@"conformToProtocol:"];
}

#pragma mark -
#pragma mark Matching

- (BOOL)evaluate {
    return [self.subject conformsToProtocol:self.protocol];
}

#pragma mark -
#pragma mark Getting Failure Messages

- (NSString *)failureMessageForShould {
    return [NSString stringWithFormat:@"expected subject to conform to %@",
                                      NSStringFromProtocol(self.protocol)];
}

#pragma mark -
#pragma mark Configuring Matchers

- (void)conformToProtocol:(Protocol *)aProtocol {
    self.protocol = aProtocol;
}

@end
