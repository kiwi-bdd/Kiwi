#import "KW_MABaseFuture.h"


@interface _KW_MASimpleFuture : KW_MABaseFuture
{
}
@end

@interface _KW_MALazyBlockFuture : _KW_MASimpleFuture
{
    id (^_block)(void);
}

- (id)initWithBlock: (id (^)(void))block;

@end

#ifdef __IPHONE_4_0

@interface _KW_IKMemoryAwareFuture : _KW_MALazyBlockFuture {
    BOOL isObserving;
    BOOL isManuallyStopped;
    NSInteger countOfUsers;
}
/*
  @abstract Use this property to check if future is observing memory warning notification or not.
 */
@property (readonly) BOOL isObserving;
/*
  @abstract Use this property to control observing of memory warning notifications. Instead of isObserving, it automatically disables observing when countOfUsers > 0 and reenables when countOfUsers == 0.
 */
@property NSInteger countOfUsers;

/*
  @abstract Called in response to UIApplicationDidReceiveMemoryWarningNotification.
  @discussion Starts processMemoryWarningUnlocked on background thread.
 */
- (void)processMemoryWarning;

/*
  @abstract Releases future and sets _resolved to NO.
  @discussion If you just want to release future, call 'invalidate' method instead.
 */
- (void)processMemoryWarningUnlocked;

/*
 @abstract Releases future and sets _resolved to NO.
 */
- (void)invalidate;

- (void)invalidateUnlocked;

/*
 @abstract Called whenever isObserver variable is changed.
 @discussion You should not call this function directly from your code. Instead, you should use isObserving property 
 to start/stop observing memory warnings notifications.
 */
- (void)setIsObservingUnlocked:(BOOL)newIsObserving;

@end

NSString* KW_IKMemoryAwareFuturesDirectory(void);

NSString* KW_IKMemoryAwareFuturePath(id future);

@interface _KW_IKAutoArchivingMemoryAwareFuture : _KW_IKMemoryAwareFuture

/*
  @abstract Archives value to the disk.
  @result YES if value is archived without errors. Otherwise NO.
*/
- (BOOL)archiveValueUnlocked;

/*
  @abstract Unarchives value from the disk.
  @result YES if value is unarchived without errors. If either archive for future doesn't exist or error is occured, returns NO. 
*/
- (BOOL)unarchiveValueUnlocked;

@end

#endif // __IPHONE_4_0
