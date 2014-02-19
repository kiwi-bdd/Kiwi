//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "TestVerifier.h"

@interface TestVerifier()

@property (nonatomic, readwrite) BOOL notifiedOfEndOfExample;

@end

@implementation TestVerifier

#pragma mark - Properties

@synthesize notifiedOfEndOfExample;

#pragma mark - Setting Subjects

- (void)setSubject:(id)anObject {
}

#pragma mark - Verifying

- (void)exampleWillEnd {
    self.notifiedOfEndOfExample = YES;
}

- (NSString *)descriptionForAnonymousItNode
{
  return @"";
}

@end
