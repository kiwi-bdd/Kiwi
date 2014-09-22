#import <Foundation/Foundation.h>


@interface KW_MAMethodSignatureCache : NSObject
{
#ifdef __IPHONE_4_0
    CFMutableDictionaryRef _cache;
#else
    NSMapTable *_cache;
#endif // __IPHONE_4_0
    NSRecursiveLock *_lock;
}

+ (KW_MAMethodSignatureCache *)sharedCache;
- (NSMethodSignature *)cachedMethodSignatureForSelector: (SEL)sel;

@end
