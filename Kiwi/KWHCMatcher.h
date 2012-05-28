/**
 * This is a minimal version of HCMatcher from the Hamcrest library, purely
 * to support Hamcrest integration with Kiwi.
 *
 * The Hamcrest project can be found here: http://code.google.com/p/hamcrest/
 *
 * NOTE: When using Hamcrest library with Kiwi include Hamcrest headers first in your specs
 *       to use proper HCMatcher protocol definition instead of this minimal version:
 *       #import <OCHamcrestIOS/OCHamcrestIOS.h>
 *       #import "Kiwi.h"
 *       See http://code.google.com/p/hamcrest/source/browse/trunk/hamcrest-objectivec/Source/Core/HCMatcher.h
 *       Link OCHamcrestIOS framework first to the test binary, prior of Kiwi Library. You can set the order in XCode
 *       target settings in the build phases tab.
 *       Failure to do so might cause endless recursion in -[HCBaseDescription appendDescriptionOf:] as it checks if
 *       HCMatcher conforms to HCSelfDescribing protocol, which is missing in this minimal version
 */

#import <Foundation/Foundation.h>

@protocol HCMatcher <NSObject>
- (BOOL)matches:(id)item;
@end
