//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "NSObject+KiwiVerifierAdditions.h"
#import "KWVerifying.h"

@implementation NSObject(KiwiVerifierAdditions)

#pragma mark -
#pragma mark Attaching to Verifiers

- (id)attachToVerifier:(id<KWVerifying>)aVerifier {
    [aVerifier setSubject:self];
    return aVerifier;
}

- (id)attachToVerifier:(id<KWVerifying>)firstVerifier verifier:(id<KWVerifying>)secondVerifier {
    [firstVerifier setSubject:self];
    [secondVerifier setSubject:self];
    return firstVerifier;
}

@end
