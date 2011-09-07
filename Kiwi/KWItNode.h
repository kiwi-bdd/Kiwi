//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"
#import "KWBlockNode.h"
#import "KWExampleNode.h"

@class KWPendingNode;
@class KWExampleGroup;

@interface KWItNode : KWBlockNode<KWExampleNode>

@property (nonatomic, assign) KWExampleGroup *exampleGroup;

#pragma mark -
#pragma mark Initializing

+ (id)itNodeWithCallSite:(KWCallSite *)aCallSite description:(NSString *)aDescription block:(KWVoidBlock)aBlock;

@end
