#import "KWCaptureSpy.h"

#import "KWObjCUtilities.h"
#import "KWValue.h"
#import "NSInvocation+KiwiAdditions.h"
#import "NSMethodSignature+KiwiAdditions.h"

@interface KWCaptureSpy()

@property (nonatomic, assign) BOOL argumentCaptured;
@property (nonatomic, assign) NSUInteger argumentIndex;
@property (nonatomic, strong) id argument;

@end

@implementation KWCaptureSpy

- (id)initWithArgumentIndex:(NSUInteger)index {
    self = [super init];
    if (self) {
        _argumentIndex = index;
        _argumentCaptured = NO;
    }
    return self;
}

- (id)argument {
    if (!_argumentCaptured) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Argument requested has yet to be captured." userInfo:nil];
    }
    return _argument;
}

- (void)object:(id)anObject didReceiveInvocation:(NSInvocation *)anInvocation {
    if (!_argumentCaptured) {
        NSMethodSignature *signature = [anInvocation methodSignature];
        const char *objCType = [signature messageArgumentTypeAtIndex:_argumentIndex];
        if (KWObjCTypeIsObject(objCType)) {
            id argument = nil;
            [anInvocation getMessageArgument:&argument atIndex:_argumentIndex];
            if (KWObjCTypeIsBlock(objCType)) {
                self.argument = [argument copy];
            } else {
                self.argument = argument;
            }
        } else {
            NSData *data = [anInvocation messageArgumentDataAtIndex:_argumentIndex];
            _argument = [KWValue valueWithBytes:[data bytes] objCType:objCType];
        }
        _argumentCaptured = YES;
    }
}

@end
