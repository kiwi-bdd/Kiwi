#import "KWMessageSpying.h"

@interface KWCaptureSpy : NSObject<KWMessageSpying>

@property (nonatomic, readonly) id argument;

- (id)initWithArgumentIndex:(NSUInteger)index;

@end
