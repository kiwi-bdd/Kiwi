//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"
#import "KWBlock.h"

@class KWCallSite;

@interface KWBlockNode : NSObject {
@private
    KWCallSite *callSite;
    NSString *description;
    KWVoidBlock block;
}

#pragma mark -
#pragma mark Initializing

- (id)initWithCallSite:(KWCallSite *)aCallSite description:(NSString *)aDescription block:(KWVoidBlock)aBlock;

#pragma mark -
#pragma mark Getting Call Sites

@property (nonatomic, readonly) KWCallSite *callSite;

#pragma mark -
#pragma mark Getting Descriptions

@property (nonatomic, copy) NSString *description;

#pragma mark -
#pragma mark Getting Blocks

@property (nonatomic, readonly) KWVoidBlock block;

#pragma mark -
#pragma mark Performing blocks

- (void)performBlock;

@end
