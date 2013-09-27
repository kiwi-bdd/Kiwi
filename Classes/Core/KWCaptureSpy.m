#import "KWCaptureSpy.h"

#import "KWObjCUtilities.h"
#import "KWNull.h"
#import "KWValue.h"
#import "NSInvocation+KiwiAdditions.h"
#import "NSMethodSignature+KiwiAdditions.h"

@interface KWCaptureSpy()

@property (nonatomic, strong) id argument;

@end

@implementation KWCaptureSpy {
	NSUInteger _argumentIndex;
}

- (id)initWithArgumentIndex:(NSUInteger)index {
    self = [super init];
    if (self) {
        _argumentIndex = index;
    }
    return self;
}

- (id)argument {
    if (!_argument) {
        @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"Argument requested has yet to be captured." userInfo:nil];
    }

	if(_argument == [KWNull null]) {
		return nil;
	}
	else {
		return [[_argument retain] autorelease];
	}
}

- (void)object:(id)anObject didReceiveInvocation:(NSInvocation *)anInvocation {
    if (!_argument) {
        NSMethodSignature *signature = [anInvocation methodSignature];
        const char *objCType = [signature messageArgumentTypeAtIndex:_argumentIndex];
        if (KWObjCTypeIsObject(objCType) || KWObjCTypeIsClass(objCType)) {
            id argument = nil;
            [anInvocation getMessageArgument:&argument atIndex:_argumentIndex];
            if (KWObjCTypeIsBlock(objCType)) {
                _argument = [argument copy];
            } else {
				if(argument == nil) {
					_argument = [[KWNull null] retain];
				}
				else {
					_argument = [argument retain];
				}
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
