//
//  KWExampleSuite.h
//  Kiwi
//
//  Created by Luke Redpath on 17/10/2011.
//  Copyright (c) 2011 Allen Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KWExampleNodeVisitor.h"

@class KWContextNode;
@class KWExampleGroup;
@class SenTestCase;

@interface KWExampleSuite : NSObject <KWExampleNodeVisitor> {
  KWContextNode *rootNode;
  NSMutableSet *exampleGroups;
  NSMutableSet *visitedNodes;
}
- (id)initWithRootNode:(KWContextNode *)contextNode;
- (void)addExampleGroup:(KWExampleGroup *)exampleGroup;
- (NSArray *)invocationsForTestCase;
@end

@interface NSInvocation (KWExampleGroup)
- (void)kw_setExampleGroup:(KWExampleGroup *)exampleGroup;
- (KWExampleGroup *)kw_exampleGroup;
@end
