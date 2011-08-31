//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "TestVerifier.h"

@interface TestVerifier()

#pragma mark -
#pragma mark Properties

@property (nonatomic, readwrite) BOOL notifiedOfEndOfExample;

@end

@implementation TestVerifier

#pragma mark -
#pragma mark Properties

@synthesize notifiedOfEndOfExample;

#pragma mark -
#pragma mark Setting Subjects

- (void)setSubject:(id)anObject {
}

#pragma mark -
#pragma mark Verifying

- (void)exampleWillEnd {
    self.notifiedOfEndOfExample = YES;
}

- (NSString *)descriptionForAnonymousItNode
{
  return @"";
}

@end
