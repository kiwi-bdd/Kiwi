NS_ROOT_CLASS
@interface KW_MAProxy
{
    Class isa;
    int32_t _refcountMinusOne;
}

+ (id)alloc;

- (void)dealloc;
- (void)finalize;
- (BOOL)isProxy;
- (id)retain;
- (void)release;
- (id)autorelease;
- (NSUInteger)retainCount;

@end

