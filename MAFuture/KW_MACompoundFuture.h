

id KW_MACompoundBackgroundFuture(id (^block)(void));
id KW_MACompoundLazyFuture(id (^block)(void));

#define KW_MACompoundBackgroundFuture(...) ((__typeof((__VA_ARGS__)()))KW_MACompoundBackgroundFuture((id (^)(void))(__VA_ARGS__)))
#define KW_MACompoundLazyFuture(...) ((__typeof((__VA_ARGS__)()))KW_MACompoundLazyFuture((id (^)(void))(__VA_ARGS__)))
