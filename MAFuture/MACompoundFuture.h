

id MACompoundBackgroundFuture(id (^block)(void));
id MACompoundLazyFuture(id (^block)(void));

#define MACompoundBackgroundFuture(...) ((__typeof((__VA_ARGS__)()))MACompoundBackgroundFuture((id (^)(void))(__VA_ARGS__)))
#define MACompoundLazyFuture(...) ((__typeof((__VA_ARGS__)()))MACompoundLazyFuture((id (^)(void))(__VA_ARGS__)))
