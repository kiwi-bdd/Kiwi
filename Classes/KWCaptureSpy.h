#import <Foundation/Foundation.h>
#import "KWMock.h"
#import "KWMessageSpying.h"

@interface KWCaptureSpy : NSObject<KWMessageSpying> {
    BOOL _argumentCaptured;
    id _argument;
    NSUInteger _argumentIndex;
}

- (id)initWithArgumentIndex:(NSUInteger)index;
@property(nonatomic, readonly, retain) id argument;

@end
