
id KW_MABackgroundFuture(id (^block)(void));
id KW_MALazyFuture(id (^block)(void));

#define KW_MABackgroundFuture(...) ((__typeof((__VA_ARGS__)()))KW_MABackgroundFuture((id (^)(void))(__VA_ARGS__)))
#define KW_MALazyFuture(...) ((__typeof((__VA_ARGS__)()))KW_MALazyFuture((id (^)(void))(__VA_ARGS__)))


#if TARGET_OS_IPHONE > 0

#ifdef __IPHONE_4_0

#pragma mark -

id KW_IKMemoryAwareFuture(id (^block)(void));
id KW_IKMemoryAwareFutureCreate(id (^block)(void));
void KW_IKMemoryAwareFutureBeginContentAccess(id future);
void KW_IKMemoryAwareFutureEndContentAccess(id future);
BOOL KW_IKMemoryAwareFutureIsObserving(id future);
void KW_IKInvalidateMemoryAwareFuture(id future);

#define KW_IKMemoryAwareFuture(...)((__typeof((__VA_ARGS__)()))KW_IKMemoryAwareFuture((id (^)(void))(__VA_ARGS__)))
#define KW_IKMemoryAwareFutureCreate(...)((__typeof((__VA_ARGS__)()))KW_IKMemoryAwareFutureCreate((id (^)(void))(__VA_ARGS__)))

#pragma mark -

id KW_IKAutoArchivingMemoryAwareFuture(id (^block)(void));
id KW_IKAutoArchivingMemoryAwareFutureCreate(id (^block)(void));

#define KW_IKAutoArchivingMemoryAwareFuture(...)((__typeof((__VA_ARGS__)()))KW_IKAutoArchivingMemoryAwareFuture((id (^)(void))(__VA_ARGS__)))

#define KW_IKAutoArchivingMemoryAwareFutureCreate(...)((__typeof((__VA_ARGS__)()))KW_IKAutoArchivingMemoryAwareFutureCreate((id (^)(void))(__VA_ARGS__)))

#endif // __IPHONE_4_0

#endif
