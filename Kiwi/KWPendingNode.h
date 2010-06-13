//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"
#import "KWExampleNode.h"

#if KW_BLOCKS_ENABLED

@class KWCallSite;

@interface KWPendingNode : NSObject<KWExampleNode> {
@private
    KWCallSite *callSite;
    NSString *description;
}

#pragma mark -
#pragma mark Initializing

- (id)initWithCallSite:(KWCallSite *)aCallSite description:(NSString *)aDescription;

+ (id)pendingNodeWithCallSite:(KWCallSite *)aCallSite description:(NSString *)aDescription;

#pragma mark -
#pragma mark Getting Call Sites

@property (nonatomic, readonly) KWCallSite *callSite;

#pragma mark -
#pragma mark Getting Descriptions

@property (nonatomic, readonly) NSString *description;

@end

#endif // #if KW_BLOCKS_ENABLED
