//
//  KWLetNode.m
//  Kiwi
//
//  Created by Adam Sharp on 27/08/13.
//  Copyright (c) 2013 Allen Ding. All rights reserved.
//

#import "KWLetNode.h"

@implementation KWLetNode

@synthesize objectRef = _objectRef;

- (instancetype)initWithSymbolName:(NSString *)aSymbolName objectRef:(__autoreleasing id *)anObjectRef block:(id (^)(void))block
{
    if ((self = [super init])) {
        _symbolName = [aSymbolName copy];
        _objectRef = anObjectRef;
        _block = [block copy];
    }
    return self;
}

+ (instancetype)letNodeWithSymbolName:(NSString *)aSymbolName objectRef:(__autoreleasing id *)anObjectRef block:(id (^)(void))block
{
    return [[self alloc] initWithSymbolName:aSymbolName objectRef:anObjectRef block:block];
}

- (id)evaluate
{
    return self.block ? self.block() : nil;
}

@end
