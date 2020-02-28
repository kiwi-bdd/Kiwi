//
//  KWBlockSignature.m
//  Kiwi
//
//  Created by Oleksa 'trimm' Korin on 4/27/16.
//  Copyright © 2016 Allen Ding. All rights reserved.
//

#import "KWBlockSignature.h"

@implementation KWBlockSignature

#pragma mark - Getting Information on Message Arguments

- (NSUInteger)numberOfMessageArguments {
    return [self numberOfArguments] - 1;
}

- (const char *)messageArgumentTypeAtIndex:(NSUInteger)anIndex {
    return [self getArgumentTypeAtIndex:anIndex + 1];
}


@end
