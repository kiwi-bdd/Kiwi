#import "KiwiConfiguration.h"
#import "KWBlockNode.h"
#import "KWExampleNode.h"

@interface KWSubjectActionNode : KWBlockNode<KWExampleNode>
#pragma mark - Initializing

+ (id)subjectActionNodeWithCallSite:(KWCallSite *)aCallSite block:(void (^)(void))block;

@end