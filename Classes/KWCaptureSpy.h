#import <Foundation/Foundation.h>
#import "KWMock.h"
#import "KWMessageSpying.h"

@interface KWCaptureSpy : NSObject<KWMessageSpying>

- (id)initWithArgumentIndex:(NSUInteger)index;

@property(nonatomic, readonly, retain) id argument;

@end
