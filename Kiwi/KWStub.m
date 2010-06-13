//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWStub.h"
#import "KWMessagePattern.h"
#import "KWObjCUtilities.h"
#import "KWStringUtilities.h"
#import "KWValue.h"

@implementation KWStub

#pragma mark -
#pragma mark Initializing

- (id)initWithMessagePattern:(KWMessagePattern *)aMessagePattern {
    return [self initWithMessagePattern:aMessagePattern value:nil];
}

- (id)initWithMessagePattern:(KWMessagePattern *)aMessagePattern value:(id)aValue {
    if ((self = [super init])) {
        messagePattern = [aMessagePattern retain];
        value = [aValue retain];
    }

    return self;
}

+ (id)stubWithMessagePattern:(KWMessagePattern *)aMessagePattern {
    return [self stubWithMessagePattern:aMessagePattern value:nil];
}

+ (id)stubWithMessagePattern:(KWMessagePattern *)aMessagePattern value:(id)aValue {
    return [[[self alloc] initWithMessagePattern:aMessagePattern value:aValue] autorelease];
}

- (void)dealloc {
    [messagePattern release];
    [value release];
    [super dealloc];
}

#pragma mark -
#pragma mark Properties

@synthesize messagePattern;
@synthesize value;

#pragma mark -
#pragma mark Processing Invocations

- (void)writeZerosToInvocationReturnValue:(NSInvocation *)anInvocation {
    NSUInteger returnLength = [[anInvocation methodSignature] methodReturnLength];

    if (returnLength == 0)
        return;

    void *bytes = malloc(returnLength);
    memset(bytes, 0, returnLength);
    [anInvocation setReturnValue:bytes];
    free(bytes);
}

- (NSData *)valueDataWithObjCType:(const char *)objCType {
    assert(self.value && "self.value must not be nil");
    NSData *data = [self.value dataForObjCType:objCType];

    if (data == nil) {
        [NSException raise:@"KWStubException" format:@"wrapped stub value type (%s) could not be converted to the target type (%s)",
                                                     [self.value objCType],
                                                     objCType];
    }

    return data;
}

- (void)writeWrappedValueToInvocationReturnValue:(NSInvocation *)anInvocation {
    assert(self.value && "self.value must not be nil");
    const char *returnType = [[anInvocation methodSignature] methodReturnType];
    NSData *data = nil;

    // When the return type is not the same as the type of the wrapped value,
    // attempt to convert the wrapped value to the desired type.
    
    if (KWObjCTypeEqualToObjCType([self.value objCType], returnType))
        data = [self.value dataValue];
    else
        data = [self valueDataWithObjCType:returnType];

    [anInvocation setReturnValue:(void *)[data bytes]];
}

- (void)writeObjectValueToInvocationReturnValue:(NSInvocation *)anInvocation {
    assert(self.value && "self.value must not be nil");
    [anInvocation setReturnValue:&value];
    NSString *selectorString = NSStringFromSelector([anInvocation selector]);
    
    // To conform to memory management conventions, retain if writing a result
    // that begins with alloc, new or contains copy.
    if (KWStringHasWordPrefix(selectorString, @"alloc") ||
        KWStringHasWordPrefix(selectorString, @"new") ||
        KWStringHasWord(selectorString, @"copy") ||
        KWStringHasWord(selectorString, @"Copy")) {
        [self.value retain];
    }
}

- (BOOL)processInvocation:(NSInvocation *)anInvocation {
    if (![self.messagePattern matchesInvocation:anInvocation])
        return NO;

    if (self.value == nil)
        [self writeZerosToInvocationReturnValue:anInvocation];
    else if ([self.value isKindOfClass:[KWValue class]])
        [self writeWrappedValueToInvocationReturnValue:anInvocation];
    else
        [self writeObjectValueToInvocationReturnValue:anInvocation];

    return YES;
}

#pragma mark -
#pragma mark Debugging

- (NSString *)description {
    return [NSString stringWithFormat:@"messagePattern: %@\nvalue: %@", self.messagePattern, self.value];
}

@end
