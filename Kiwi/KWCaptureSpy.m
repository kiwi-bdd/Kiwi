#import "KWCaptureSpy.h"
#import "KWObjCUtilities.h"
#import "NSInvocation+KiwiAdditions.h"
#import "NSMethodSignature+KiwiAdditions.h"
#import "KWValue.h"

@implementation KWCaptureSpy
@dynamic argument;

- (id)initWithArgumentIndex:(NSUInteger)index {
    if ((self = [super init])) {
        _argumentIndex = index;
    }
    return self;
}

- (id)argument {
    if (!_argument) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Argument requested has yet to be captured." userInfo:nil];    
    }
    return [[_argument retain] autorelease];
}

- (void)object:(id)anObject didReceiveInvocation:(NSInvocation *)anInvocation {
    if (!_argument) {
        NSMethodSignature *signature = [anInvocation methodSignature];
        const char *objCType = [signature messageArgumentTypeAtIndex:_argumentIndex];        
        if (KWObjCTypeIsObject(objCType)) {
            id argument = nil;
            [anInvocation getMessageArgument:&argument atIndex:_argumentIndex];
            if (KWObjCTypeIsBlock(objCType)) {
                _argument = [argument copy];
            } else {
                _argument = [argument retain];
            }                
        } else {
            NSData *data = [anInvocation messageArgumentDataAtIndex:_argumentIndex];
            _argument = [[KWValue valueWithBytes:[data bytes] objCType:objCType] retain];
        }
    }
}

- (void)dealloc {
    [_argument release];
    [super dealloc];
}
@end
