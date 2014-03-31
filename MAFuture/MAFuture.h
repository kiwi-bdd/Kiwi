
id MABackgroundFuture(id (^block)(void));
id MALazyFuture(id (^block)(void));

#define MABackgroundFuture(...) ((__typeof((__VA_ARGS__)()))MABackgroundFuture((id (^)(void))(__VA_ARGS__)))
#define MALazyFuture(...) ((__typeof((__VA_ARGS__)()))MALazyFuture((id (^)(void))(__VA_ARGS__)))


#if TARGET_OS_IPHONE > 0

#ifdef __IPHONE_4_0

#pragma mark -

id IKMemoryAwareFuture(id (^block)(void));
id IKMemoryAwareFutureCreate(id (^block)(void));
void IKMemoryAwareFutureBeginContentAccess(id future);
void IKMemoryAwareFutureEndContentAccess(id future);
BOOL IKMemoryAwareFutureIsObserving(id future);
void IKInvalidateMemoryAwareFuture(id future);

#define IKMemoryAwareFuture(...)((__typeof((__VA_ARGS__)()))IKMemoryAwareFuture((id (^)(void))(__VA_ARGS__)))
#define IKMemoryAwareFutureCreate(...)((__typeof((__VA_ARGS__)()))IKMemoryAwareFutureCreate((id (^)(void))(__VA_ARGS__)))

#pragma mark -

id IKAutoArchivingMemoryAwareFuture(id (^block)(void));
id IKAutoArchivingMemoryAwareFutureCreate(id (^block)(void));

#define IKAutoArchivingMemoryAwareFuture(...)((__typeof((__VA_ARGS__)()))IKAutoArchivingMemoryAwareFuture((id (^)(void))(__VA_ARGS__)))

#define IKAutoArchivingMemoryAwareFutureCreate(...)((__typeof((__VA_ARGS__)()))IKAutoArchivingMemoryAwareFutureCreate((id (^)(void))(__VA_ARGS__)))

#endif // __IPHONE_4_0

#endif
