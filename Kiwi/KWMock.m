//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWMock.h"
#import </usr/include/objc/runtime.h>
#import "KWFormatter.h"
#import "KWMessagePattern.h"
#import "KWMessageSpying.h"
#import "KWStringUtilities.h"
#import "KWStub.h"
#import "KWWorkarounds.h"
#import "NSInvocation+KiwiAdditions.h"

static NSString * const ExpectOrStubTagKey = @"ExpectOrStubTagKey";
static NSString * const StubTag = @"StubTag";
static NSString * const ExpectTag = @"ExpectTag";
static NSString * const StubValueKey = @"StubValueKey";

@interface KWMock()

#pragma mark -
#pragma mark Initializing

- (id)initAsNullMock:(BOOL)nullMockFlag withName:(NSString *)aName forClass:(Class)aClass protocol:(Protocol *)aProtocol;

#pragma mark -
#pragma mark Properties

@property (nonatomic, readonly) NSMutableArray *stubs;
@property (nonatomic, readonly) NSMutableArray *expectedMessagePatterns;
@property (nonatomic, readonly) NSMutableDictionary *messageSpies;


#pragma mark -
#pragma mark Handling Invocations

- (BOOL)processReceivedInvocation:(NSInvocation *)invocation;

@end

@implementation KWMock

#pragma mark -
#pragma mark Initializing

- (id)init {
    // May already have been initialized since stubbing -init is allowed!
    if (self.stubs != nil) {
        KWMessagePattern *messagePattern = [KWMessagePattern messagePatternWithSelector:_cmd];
        [self expectMessagePattern:messagePattern];
        NSInvocation *invocation = [NSInvocation invocationWithTarget:self selector:_cmd];
        
        if ([self processReceivedInvocation:invocation]) {
            id result = nil;
            [invocation getReturnValue:&result];
            return result;
        } else {
            return self;
        }        
    }
    
    return [self initAsNullMock:NO withName:nil forClass:nil protocol:nil];
}

- (id)initForClass:(Class)aClass {
    return [self initAsNullMock:NO withName:nil forClass:aClass protocol:nil];
}

- (id)initForProtocol:(Protocol *)aProtocol {
    return [self initAsNullMock:NO withName:nil forClass:nil protocol:aProtocol];
}

- (id)initWithName:(NSString *)aName forClass:(Class)aClass {
    return [self initAsNullMock:NO withName:aName forClass:aClass protocol:nil];
}

- (id)initWithName:(NSString *)aName forProtocol:(Protocol *)aProtocol {
    return [self initAsNullMock:NO withName:aName forClass:nil protocol:aProtocol];
}

- (id)initAsNullMockForClass:(Class)aClass {
    return [self initAsNullMock:YES withName:nil forClass:aClass protocol:nil];
}

- (id)initAsNullMockForProtocol:(Protocol *)aProtocol {
    return [self initAsNullMock:YES withName:nil forClass:nil protocol:aProtocol];
}

- (id)initAsNullMockWithName:(NSString *)aName forClass:(Class)aClass {
    return [self initAsNullMock:YES withName:aName forClass:aClass protocol:nil];
}

- (id)initAsNullMockWithName:(NSString *)aName forProtocol:(Protocol *)aProtocol {
    return [self initAsNullMock:YES withName:aName forClass:nil protocol:aProtocol];
}

- (id)initAsNullMock:(BOOL)nullMockFlag withName:(NSString *)aName forClass:(Class)aClass protocol:(Protocol *)aProtocol {
    if ((self = [super init])) {
        isNullMock = nullMockFlag;
        name = [aName copy];
        mockedClass = aClass;
        mockedProtocol = aProtocol;
        stubs = [[NSMutableArray alloc] init];
        expectedMessagePatterns = [[NSMutableArray alloc] init];
        messageSpies = [[NSMutableDictionary alloc] init];
    }

    return self;
}

+ (id)mockForClass:(Class)aClass {
    return [[[self alloc] initForClass:aClass] autorelease];
}

+ (id)mockForProtocol:(Protocol *)aProtocol {
    return [[[self alloc] initForProtocol:aProtocol] autorelease];
}

+ (id)mockWithName:(NSString *)aName forClass:(Class)aClass {
    return [[[self alloc] initWithName:aName forClass:aClass] autorelease];
}

+ (id)mockWithName:(NSString *)aName forProtocol:(Protocol *)aProtocol {
    return [[[self alloc] initWithName:aName forProtocol:aProtocol] autorelease];
}

+ (id)nullMockForClass:(Class)aClass {
    return [[[self alloc] initAsNullMockForClass:aClass] autorelease];
}

+ (id)nullMockForProtocol:(Protocol *)aProtocol {
    return [[[self alloc] initAsNullMockForProtocol:aProtocol] autorelease];
}

+ (id)nullMockWithName:(NSString *)aName forClass:(Class)aClass {
    return [[[self alloc] initAsNullMockWithName:aName forClass:aClass] autorelease];
}

+ (id)nullMockWithName:(NSString *)aName forProtocol:(Protocol *)aProtocol {
    return [[[self alloc] initAsNullMockWithName:aName forProtocol:aProtocol] autorelease];
}

- (void)dealloc {
    [name release];
    [stubs release];
    [expectedMessagePatterns release];
    [messageSpies release];
    [super dealloc];
}

#pragma mark -
#pragma mark Properties

@synthesize isNullMock;
@synthesize name;
@synthesize mockedClass;
@synthesize mockedProtocol;
@synthesize stubs;
@synthesize expectedMessagePatterns;
@synthesize messageSpies;

#pragma mark -
#pragma mark Getting Transitive Closure For Mocked Protocols

- (NSSet *)mockedProtocolTransitiveClosureSet {
    if (self.mockedProtocol == nil)
        return nil;
    
    NSMutableSet *protocolSet = [NSMutableSet set];
    NSMutableArray *protocolQueue = [NSMutableArray array];
    [protocolQueue addObject:self.mockedProtocol];
    
    do {
        Protocol *protocol = [protocolQueue lastObject];
        [protocolSet addObject:protocol];
        [protocolQueue removeLastObject];
        
        unsigned int count = 0;
        Protocol **protocols = protocol_copyProtocolList(protocol, &count);
        
        if (count == 0)
            continue;
        
        for (unsigned int i = 0; i < count; ++i)
            [protocolQueue addObject:protocols[i]];
        
        free(protocols);
    } while ([protocolQueue count] != 0);
    
    return protocolSet;
}

#pragma mark -
#pragma mark Stubbing Methods

- (void)removeStubWithMessagePattern:(KWMessagePattern *)messagePattern {
    NSUInteger stubCount = [self.stubs count];

    for (int i = 0; i < stubCount; ++i) {
        KWStub *stub = [self.stubs objectAtIndex:i];

        if ([stub.messagePattern isEqualToMessagePattern:messagePattern]) {
            [self.stubs removeObjectAtIndex:i];
            return;
        }
    }
}

- (void)stub:(SEL)aSelector {
    KWMessagePattern *messagePattern = [KWMessagePattern messagePatternWithSelector:aSelector];
    [self stubMessagePattern:messagePattern andReturn:nil];
}

- (void)stub:(SEL)aSelector withArguments:(id)firstArgument, ... {
    va_list argumentList;
    va_start(argumentList, firstArgument);
    KWMessagePattern *messagePattern = [KWMessagePattern messagePatternWithSelector:aSelector firstArgumentFilter:firstArgument argumentList:argumentList];
    [self stubMessagePattern:messagePattern andReturn:nil];
}

- (void)stub:(SEL)aSelector andReturn:(id)aValue {
    KWMessagePattern *messagePattern = [KWMessagePattern messagePatternWithSelector:aSelector];
    [self stubMessagePattern:messagePattern andReturn:aValue];
}

- (void)stub:(SEL)aSelector andReturn:(id)aValue withArguments:(id)firstArgument, ... {
    va_list argumentList;
    va_start(argumentList, firstArgument);
    KWMessagePattern *messagePattern = [KWMessagePattern messagePatternWithSelector:aSelector firstArgumentFilter:firstArgument argumentList:argumentList];
    [self stubMessagePattern:messagePattern andReturn:aValue];
}

- (id)stub {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:StubTag forKey:ExpectOrStubTagKey];
    return [KWInvocationCapturer invocationCapturerWithDelegate:self userInfo:userInfo];
}

- (id)stubAndReturn:(id)aValue {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:StubTag, ExpectOrStubTagKey,
                                                                        aValue, StubValueKey, nil];
    return [KWInvocationCapturer invocationCapturerWithDelegate:self userInfo:userInfo];
}

- (void)stubMessagePattern:(KWMessagePattern *)aMessagePattern andReturn:(id)aValue {
    [self expectMessagePattern:aMessagePattern];
    [self removeStubWithMessagePattern:aMessagePattern];
    KWStub *stub = [KWStub stubWithMessagePattern:aMessagePattern value:aValue];
    [self.stubs addObject:stub];
}

- (void)clearStubs {
    [self.stubs removeAllObjects];
}

#pragma mark -
#pragma mark Spying on Messages

- (void)addMessageSpy:(id<KWMessageSpying>)aSpy forMessagePattern:(KWMessagePattern *)aMessagePattern {
    [self expectMessagePattern:aMessagePattern];
    NSMutableArray *messagePatternSpies = [self.messageSpies objectForKey:aMessagePattern];

    if (messagePatternSpies == nil) {
        messagePatternSpies = [[NSMutableArray alloc] init];
        [self.messageSpies setObject:messagePatternSpies forKey:aMessagePattern];
        [messagePatternSpies release];
    }
    NSValue *spyWrapper = [NSValue valueWithNonretainedObject:aSpy];

    if (![messagePatternSpies containsObject:spyWrapper])
        [messagePatternSpies addObject:spyWrapper];
}

- (void)removeMessageSpy:(id<KWMessageSpying>)aSpy forMessagePattern:(KWMessagePattern *)aMessagePattern {
    NSValue *spyWrapper = [NSValue valueWithNonretainedObject:aSpy];
    NSMutableArray *messagePatternSpies = [self.messageSpies objectForKey:aMessagePattern];
    [messagePatternSpies removeObject:spyWrapper];
}

#pragma mark -
#pragma mark Expecting Message Patterns

- (void)expect:(SEL)aSelector {
    KWMessagePattern *messagePattern = [KWMessagePattern messagePatternWithSelector:aSelector];
    [self expectMessagePattern:messagePattern];
}

- (void)expect:(SEL)aSelector withArguments:(id)firstArgument, ... {
    va_list argumentList;
    va_start(argumentList, firstArgument);
    KWMessagePattern *messagePattern = [KWMessagePattern messagePatternWithSelector:aSelector firstArgumentFilter:firstArgument argumentList:argumentList];
    [self expectMessagePattern:messagePattern];
}

- (id)expect {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:ExpectTag forKey:ExpectOrStubTagKey];
    return [KWInvocationCapturer invocationCapturerWithDelegate:self userInfo:userInfo];
}

- (void)expectMessagePattern:(KWMessagePattern *)aMessagePattern {
    if (![self.expectedMessagePatterns containsObject:aMessagePattern])
        [self.expectedMessagePatterns addObject:aMessagePattern];
}

#pragma mark -
#pragma mark Capturing Invocations

- (NSMethodSignature *)invocationCapturer:(KWInvocationCapturer *)anInvocationCapturer methodSignatureForSelector:(SEL)aSelector {
    return [self methodSignatureForSelector:aSelector];
}

- (void)invocationCapturer:(KWInvocationCapturer *)anInvocationCapturer didCaptureInvocation:(NSInvocation *)anInvocation {
    KWMessagePattern *messagePattern = [KWMessagePattern messagePatternFromInvocation:anInvocation];
    NSString *tag = [anInvocationCapturer.userInfo objectForKey:ExpectOrStubTagKey];

    if ([tag isEqualToString:StubTag]) {
        id value = [anInvocationCapturer.userInfo objectForKey:StubValueKey];
        [self stubMessagePattern:messagePattern andReturn:value];
    } else {
        [self expectMessagePattern:messagePattern];
    }
}

#pragma mark -
#pragma mark Handling Invocations

- (NSString *)namePhrase {
    if (self.name == nil)
        return @"mock";
    else
        return [NSString stringWithFormat:@"mock \"%@\"", self.name];
}

- (BOOL)processReceivedInvocation:(NSInvocation *)invocation {  
    for (KWMessagePattern *messagePattern in self.messageSpies) {
        if ([messagePattern matchesInvocation:invocation]) {
            NSArray *spies = [self.messageSpies objectForKey:messagePattern];
            
            for (NSValue *spyWrapper in spies) {
                id spy = [spyWrapper nonretainedObjectValue];
                [spy object:self didReceiveInvocation:invocation];
            }
        }
    }
    
    for (KWStub *stub in self.stubs) {
        if ([stub processInvocation:invocation])
            return YES;
    }
    
    return NO;
}

- (NSMethodSignature *)mockedProtocolMethodSignatureForSelector:(SEL)aSelector {
    NSSet *protocols = [self mockedProtocolTransitiveClosureSet];
    
    for (Protocol *protocol in protocols) {
        struct objc_method_description description = protocol_getMethodDescription(protocol, aSelector, NO, YES);
        
        if (description.types == nil)
            description = protocol_getMethodDescription(protocol, aSelector, YES, YES);
        
        if (description.types != nil)
            return [NSMethodSignature signatureWithObjCTypes:description.types];
    }
    
    return nil;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *methodSignature = [self.mockedClass instanceMethodSignatureForSelector:aSelector];
    
    if (methodSignature != nil)
        return methodSignature;
    
    methodSignature = [self mockedProtocolMethodSignatureForSelector:aSelector];
    
    if (methodSignature != nil)
        return methodSignature;

    NSString *encoding = KWEncodingForVoidMethod();
    return [NSMethodSignature signatureWithObjCTypes:[encoding UTF8String]];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
#if KW_TARGET_HAS_INVOCATION_EXCEPTION_BUG
    @try {
#endif // #if KW_TARGET_HAS_INVOCATION_EXCEPTION_BUG

    if ([self processReceivedInvocation:anInvocation])
        return;
    
    if (self.isNullMock)
        return;

    for (KWMessagePattern *expectedMessagePattern in self.expectedMessagePatterns) {
        if ([expectedMessagePattern matchesInvocation:anInvocation])
            return;
    }
    
    KWMessagePattern *messagePattern = [KWMessagePattern messagePatternFromInvocation:anInvocation];
    [NSException raise:@"KWMockException" format:@"%@ received unexpected message -%@",
                                                 [self namePhrase],
                                                 [messagePattern stringValue]];

#if KW_TARGET_HAS_INVOCATION_EXCEPTION_BUG
    } @catch (NSException *exception) {
        KWSetExceptionFromAcrossInvocationBoundary(exception);
    }
#endif // #if KW_TARGET_HAS_INVOCATION_EXCEPTION_BUG
}

#pragma mark -
#pragma mark Testing Objects

- (BOOL)mockedClassHasAncestorClass:(Class)aClass {
    Class currentClass = self.mockedClass;

    while (currentClass != nil) {
        if (currentClass == aClass)
            return YES;

        currentClass = [currentClass superclass];
    }

    return NO;
}

- (BOOL)mockedClassRespondsToSelector:(SEL)aSelector {
    return [self.mockedClass instancesRespondToSelector:aSelector];
}

- (BOOL)mockedClassConformsToProtocol:(Protocol *)aProtocol {
    return [self.mockedClass conformsToProtocol:aProtocol];
}

- (BOOL)mockedProtocolRespondsToSelector:(SEL)aSelector {
    NSSet *protocols = [self mockedProtocolTransitiveClosureSet];
    
    for (Protocol *protocol in protocols) {
        struct objc_method_description description = protocol_getMethodDescription(protocol, aSelector, NO, YES);
        
        if (description.types == nil)
            description = protocol_getMethodDescription(protocol, aSelector, YES, YES);
        
        if (description.types != nil)
            return YES;
    }
    
    return NO;    
}

- (BOOL)mockedProtocolConformsToProtocol:(Protocol *)aProtocol {
    if (self.mockedProtocol == nil)
        return NO;
    
    return protocol_isEqual(self.mockedProtocol, aProtocol) || protocol_conformsToProtocol(self.mockedProtocol, aProtocol);
}

- (BOOL)isKindOfClass:(Class)aClass {
    return [self mockedClassHasAncestorClass:aClass] || [super isKindOfClass:aClass];
}

- (BOOL)isMemberOfClass:(Class)aClass {
    return self.mockedClass == aClass || [super isMemberOfClass:aClass];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [self mockedClassRespondsToSelector:aSelector] ||
           [self mockedProtocolRespondsToSelector:aSelector] ||
           [super respondsToSelector:aSelector];
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    return [self mockedClassConformsToProtocol:aProtocol] ||
           [self mockedProtocolConformsToProtocol:aProtocol] ||
           [super conformsToProtocol:aProtocol];
}

#pragma mark -
#pragma mark Whitelisted NSObject Methods

- (BOOL)isEqual:(id)anObject {
    KWMessagePattern *messagePattern = [KWMessagePattern messagePatternWithSelector:_cmd];
    [self expectMessagePattern:messagePattern];
    NSInvocation *invocation = [NSInvocation invocationWithTarget:self selector:_cmd messageArguments:&anObject];
    
    if ([self processReceivedInvocation:invocation]) {
        BOOL result = NO;
        [invocation getReturnValue:&result];
        return result;
    } else {
        return [super isEqual:anObject];
    }
}

- (NSUInteger)hash {
    KWMessagePattern *messagePattern = [KWMessagePattern messagePatternWithSelector:_cmd];
    [self expectMessagePattern:messagePattern];
    NSInvocation *invocation = [NSInvocation invocationWithTarget:self selector:_cmd];

    if ([self processReceivedInvocation:invocation]) {
        NSUInteger result = 0;
        [invocation getReturnValue:&result];
        return result;
    } else {
        return [super hash];
    }
}

- (NSString *)description {
    KWMessagePattern *messagePattern = [KWMessagePattern messagePatternWithSelector:_cmd];
    [self expectMessagePattern:messagePattern];
    NSInvocation *invocation = [NSInvocation invocationWithTarget:self selector:_cmd];
    
    if ([self processReceivedInvocation:invocation]) {
        NSString *result = nil;
        [invocation getReturnValue:&result];
        return result;
    } else {
        return [super description];
    }
}

- (id)copy {
    KWMessagePattern *messagePattern = [KWMessagePattern messagePatternWithSelector:_cmd];
    [self expectMessagePattern:messagePattern];
    NSInvocation *invocation = [NSInvocation invocationWithTarget:self selector:_cmd];
    
    if ([self processReceivedInvocation:invocation]) {
        id result = nil;
        [invocation getReturnValue:&result];
        return result;
    } else {
        return [super copy];
    }
}

- (id)mutableCopy {
    KWMessagePattern *messagePattern = [KWMessagePattern messagePatternWithSelector:_cmd];
    [self expectMessagePattern:messagePattern];
    NSInvocation *invocation = [NSInvocation invocationWithTarget:self selector:_cmd];
    
    if ([self processReceivedInvocation:invocation]) {
        id result = nil;
        [invocation getReturnValue:&result];
        return result;
    } else {
        return [super mutableCopy];
    }
}

@end
