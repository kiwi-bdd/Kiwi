#import <Foundation/Foundation.h>


@interface MAMethodSignatureCache : NSObject
{
#ifdef __IPHONE_4_0
    CFMutableDictionaryRef _cache;
#else
    NSMapTable *_cache;
#endif // __IPHONE_4_0
    NSRecursiveLock *_lock;
}

+ (MAMethodSignatureCache *)sharedCache;
- (NSMethodSignature *)cachedMethodSignatureForSelector: (SEL)sel;

@end
