//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"

typedef void (^KWVoidBlock)(void);

@interface KWBlock : NSObject {
@private
    KWVoidBlock block;
}

#pragma mark -
#pragma mark Initializing
- (id)initWithBlock:(KWVoidBlock)aBlock;

+ (id)blockWithBlock:(KWVoidBlock)aBlock;

#pragma mark -
#pragma mark Calling Blocks

- (void)call;

@end

#pragma mark -
#pragma mark Creating Blocks

KWBlock *theBlock(KWVoidBlock aBlock);
KWBlock *lambda(KWVoidBlock aBlock);
