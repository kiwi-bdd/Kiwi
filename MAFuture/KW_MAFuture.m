#import <dispatch/dispatch.h>
#import <Foundation/Foundation.h>

#import "KW_MABaseFuture.h"
#import "KW_MAFuture.h"
#import "KW_MAFutureInternal.h"
#import "KW_MAMethodSignatureCache.h"


extern NSString *const UIApplicationDidReceiveMemoryWarningNotification;


#define ENABLE_LOGGING 0

#if ENABLE_LOGGING
#define LOG(...) NSLog(__VA_ARGS__)
#else
#define LOG(...)
#endif

@implementation _KW_MASimpleFuture

- (id)forwardingTargetForSelector: (SEL)sel
{
    LOG(@"%p forwardingTargetForSelector: %@, resolving future", self, NSStringFromSelector(sel));
#if ENABLE_LOGGING
    id resolvedFuture = [self resolveFuture];
    if (resolvedFuture == nil) {
        LOG(@"WARNING: [%@ resolveFuture] has returned nil. You must avoid to return nil objects from the block", NSStringFromClass(isa));
    }
    return resolvedFuture;
#else
    return [self resolveFuture];
#endif
}

- (NSMethodSignature *)methodSignatureForSelector: (SEL)sel
{
    return [[KW_MAMethodSignatureCache sharedCache] cachedMethodSignatureForSelector: sel];
}

- (void)forwardInvocation: (NSInvocation *)inv
{
    // this gets hit if the future resolves to nil
    // zero-fill the return value
    char returnValue[[[inv methodSignature] methodReturnLength]];
    bzero(returnValue, sizeof(returnValue));
    [inv setReturnValue: returnValue];
}

@end


@interface _KW_MABackgroundBlockFuture : _KW_MASimpleFuture
{
}
@end

@implementation _KW_MABackgroundBlockFuture

- (id)initWithBlock: (id (^)(void))block
{
    if((self = [self init]))
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self setFutureValue: block()];
        });
    }
    return self;
}

- (id)resolveFuture
{
    return [self waitForFutureResolution];
}

@end


@implementation _KW_MALazyBlockFuture

- (id)initWithBlock: (id (^)(void))block
{
    if((self = [self init]))
    {
        _block = [block copy];
    }
    return self;
}

- (void)dealloc
{
    [_block release];
    [super dealloc];
}

- (id)resolveFuture
{
    [_lock lock];
    if(![self futureHasResolved])
    {
        [self setFutureValueUnlocked: _block()];
        [_block release];
        _block = nil;
    }
    [_lock unlock];
    return _value;
}

@end

#undef KW_MABackgroundFuture
id KW_MABackgroundFuture(id (^block)(void))
{
    return [[[_KW_MABackgroundBlockFuture alloc] initWithBlock: block] autorelease];
}

#undef KW_MALazyFuture
id KW_MALazyFuture(id (^block)(void))
{
    return [[[_KW_MALazyBlockFuture alloc] initWithBlock: block] autorelease];
}

#pragma mark -
#pragma mark iOS Futures

#if TARGET_OS_IPHONE > 0

#ifdef __IPHONE_4_0

@implementation _KW_IKMemoryAwareFuture
@synthesize isObserving;
@dynamic countOfUsers;

- (NSInteger)countOfUsers {
    return countOfUsers;
}


- (void)setCountOfUsers:(NSInteger)newCountOfUsers {
    [_lock lock];
    countOfUsers = newCountOfUsers < 0 ? 0 : newCountOfUsers;
    BOOL newIsObserving = (countOfUsers == 0);
    if (newIsObserving && isManuallyStopped) {
        isManuallyStopped = NO;
        if ([self futureHasResolved]) {
            // If future is resolved set isObserving back to YES.
            // Otherwise this will be set to YES just after resolving.
            [self setIsObservingUnlocked:YES];
        }
    }
    else if (!newIsObserving && !isManuallyStopped) {
        isManuallyStopped = YES;
        if ([self futureHasResolved]) {
            // If future is resolved set isObserving to NO.
            // Otherwise this is already set to NO.
            [self setIsObservingUnlocked:NO];
        }
    }
    [_lock unlock];
}


- (id)futureValue {
    return [[[super futureValue] retain] autorelease];
}


- (void)setIsObservingUnlocked:(BOOL)newIsObserving {
    if (isObserving != newIsObserving) {
        if (newIsObserving) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processMemoryWarning) 
                                                         name:UIApplicationDidReceiveMemoryWarningNotification 
                                                       object:nil];
        }
        else {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        }
        isObserving = newIsObserving;
    }
}


- (void)dealloc {
    [self setIsObservingUnlocked:NO];
    [super dealloc];
}


- (id)resolveFuture {
    [_lock lock];
    if(![self futureHasResolved])
    {
        [self setFutureValueUnlocked: _block()];
        if (!isManuallyStopped) {
            [self setIsObservingUnlocked:YES];
        }
    }
    [_lock unlock];
    return _value;
}


- (void)processMemoryWarning {
    [_lock lock];
    [self setIsObservingUnlocked:NO];
    [self processMemoryWarningUnlocked];
    [_lock unlock];
}


- (void)processMemoryWarningUnlocked {
    // TODO: must be checked when resolvation algorithm is changed.
    _resolved = NO;
    [_value release], _value = nil;
}


- (void)invalidate {
    [_lock lock];
    [self invalidateUnlocked];
    [_lock unlock];
}


- (void)invalidateUnlocked {
    // TODO: must be checked when resolvation algorithm is changed.
    [self setIsObservingUnlocked:NO];
    _resolved = NO;
    [_value release], _value = nil;
}

@end

#undef KW_IKMemoryAwareFutureCreate
id KW_IKMemoryAwareFutureCreate(id (^block)(void)) {
    return [[_KW_IKMemoryAwareFuture alloc] initWithBlock:block];
}

#undef KW_IKMemoryAwareFuture
id KW_IKMemoryAwareFuture(id (^block)(void)) {
    return [KW_IKMemoryAwareFutureCreate(block) autorelease];
}

void KW_IKMemoryAwareFutureBeginContentAccess(id future) {
    ((_KW_IKMemoryAwareFuture *)future).countOfUsers += 1;
}

void KW_IKMemoryAwareFutureEndContentAccess(id future) {
    ((_KW_IKMemoryAwareFuture *)future).countOfUsers -= 1;
}

BOOL KW_IKMemoryAwareFutureIsObserving(id future) {
    return [future isObserving];
}

void KW_IKInvalidateMemoryAwareFuture(id future) {
    [future invalidate];
}

NSString* KW_IKMemoryAwareFuturesDirectory(void) {
    static NSString* FuturesDirectory = nil;
    if (FuturesDirectory == nil) {
        FuturesDirectory = [[NSTemporaryDirectory() stringByAppendingPathComponent:@"futures"] retain];
    }
    return FuturesDirectory;
}

NSString* KW_IKMemoryAwareFuturePath(id future) {
    return [KW_IKMemoryAwareFuturesDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%p", future]];
}

@implementation _KW_IKAutoArchivingMemoryAwareFuture

+ (void)initialize {
    if ([NSStringFromClass(self) isEqualToString:@"KW_IKAutoArchivingMemoryAwareFuture"]) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *futuresDirectory = KW_IKMemoryAwareFuturesDirectory();
#if ENABLE_LOGGING
        NSError *error = nil;
        if (![fileManager removeItemAtPath:futuresDirectory error:&error]) {
            LOG(@"IKAAMAF: Error is occured while trying to remove old futures directory at path \"%@\": %@",
                futuresDirectory, [error localizedDescription]);
        }
        if (![fileManager createDirectoryAtPath:futuresDirectory withIntermediateDirectories:NO attributes:nil error:&error]) {
            LOG(@"IKAAMAF: Error is occured while trying to create temporary directory for futures at path \"%@\": %@",
                futuresDirectory, [error localizedDescription]);
        }
#else
        [fileManager removeItemAtPath:futuresDirectory error:NULL];
        [fileManager createDirectoryAtPath:futuresDirectory withIntermediateDirectories:NO attributes:nil error:NULL];
#endif
    }
}


- (void)dealloc {
#if ENABLE_LOGGING
    NSError *error = nil;
    if (![[NSFileManager defaultManager] removeItemAtPath:KW_IKMemoryAwareFuturePath(self) error:&error]) {
        LOG(@"IKAAMAF: Error is occured while trying to delete file for future %@ at path \"%@\": %@", 
            self, KW_IKMemoryAwareFuturePath(self), [error localizedDescription]);
    }
#else
    [[NSFileManager defaultManager] removeItemAtPath:KW_IKMemoryAwareFuturePath(self) error:NULL];
#endif
    [super dealloc];
}


- (id)resolveFuture {
    [_lock lock];
    if(![self futureHasResolved])
    {
        // Try to decode object from file.
        if (![self unarchiveValueUnlocked]) {
            // If cannot to decode object, create it.
            [self setFutureValueUnlocked: _block()];
        }
        
        if (!isManuallyStopped) {
            [self setIsObservingUnlocked:YES];
        }
    }
    [_lock unlock];
    return _value;
}


- (void)processMemoryWarningUnlocked {
    [self archiveValueUnlocked];
    [super processMemoryWarningUnlocked];
}


- (BOOL)archiveValueUnlocked {
#if ENABLE_LOGGING
    BOOL result = [NSKeyedArchiver archiveRootObject:_value toFile:KW_IKMemoryAwareFuturePath(self)];
    if (!result) {
        LOG(@"IKAAMAF: Cannot encode value at path \"%@\"", KW_IKMemoryAwareFuturePath(self));
    }
    return result;
#else
    return [NSKeyedArchiver archiveRootObject:_value toFile:KW_IKMemoryAwareFuturePath(self)];
#endif
}


- (BOOL)unarchiveValueUnlocked {
    id value = [[[NSKeyedUnarchiver unarchiveObjectWithFile:KW_IKMemoryAwareFuturePath(self)] retain] autorelease];
    if (value != nil) {
        [self setFutureValueUnlocked:value];
    }
#if ENABLE_LOGGING
    else {
        LOG(@"IKAAMAF: Cannot decode value at path \"%@\"", KW_IKMemoryAwareFuturePath(self));
    }
#endif
    return [self futureHasResolved];
}


- (void)invalidateUnlocked {
    [super invalidateUnlocked];
    [[NSFileManager defaultManager] removeItemAtPath:KW_IKMemoryAwareFuturePath(self) error:NULL];
}

@end

#undef KW_IKAutoArchivingMemoryAwareFutureCreate
id KW_IKAutoArchivingMemoryAwareFutureCreate(id (^block)(void)) {
    // TODO: Find a way to check up the object is returned by the block conforms to the NSCoding protocol.
    return [[_KW_IKAutoArchivingMemoryAwareFuture alloc] initWithBlock:block];
}

#undef KW_IKAutoArchivingMemoryAwareFuture
id KW_IKAutoArchivingMemoryAwareFuture(id (^block)(void)) {
    return [KW_IKAutoArchivingMemoryAwareFutureCreate(block) autorelease];
}

#endif // __IPHONE_4_0

#endif
