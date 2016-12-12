#import "KWMessageSpying.h"

@interface KWCaptureSpy : NSObject<KWMessageSpying>

@property (nonatomic, strong, readonly) id argument;
@property (nonatomic, readonly, getter=isCaptured) BOOL captured;

- (id)initWithArgumentIndex:(NSUInteger)index;

@end
