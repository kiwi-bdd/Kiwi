/**
 * This is a minimal version of HCMatcher from the Hamcrest library, purely
 * to support Hamcrest integration with Kiwi.
 *
 * The Hamcrest project can be found here: http://code.google.com/p/hamcrest/
 */

#import <Foundation/Foundation.h>

// Use HCMatcher protocol definition from Hamcrest library when available
#if !defined(HC_assertThat) 

@protocol HCMatcher <NSObject>
- (BOOL)matches:(id)item;
@end

#endif
