#import "KWSubjectActionNode.h"
#import "KWExampleNodeVisitor.h"

@implementation KWSubjectActionNode
#pragma mark - Initializing

+ (id)subjectActionNodeWithCallSite:(KWCallSite *)aCallSite block:(void (^)(void))block {
    return [[self alloc] initWithCallSite:aCallSite description:nil block:block];
}

#pragma mark - Accepting Visitors

- (void)acceptExampleNodeVisitor:(id<KWExampleNodeVisitor>)aVisitor {
    [aVisitor visitSubjectActionNode:self];
}
@end
