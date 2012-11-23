//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "NSObject+KiwiSpyAdditions.h"

@implementation NSObject (KiwiSpyAdditions)

- (KWCaptureSpy *)captureArgument:(SEL)selector atIndex:(NSUInteger)index
{
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"captureArgument:atIndex: called on an object which is not a mock." userInfo:nil];
}

@end
