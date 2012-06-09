/**
 * This is a minimal version of HCMatcher from the Hamcrest library, purely
 * to support Hamcrest integration with Kiwi.
 *
 * The Hamcrest project can be found here: http://code.google.com/p/hamcrest/
 */

#import <Foundation/Foundation.h>

#if !defined(HCMatcher)

@protocol HCMatcher <NSObject>
- (BOOL)matches:(id)item;
@end

#else
    #if !defined(HCSelfDescribing)
        #warning defined HCMatcher does not seem to be a hamcrest HCMatcher as it should implement HCSelfDescribing
    #endif
#endif