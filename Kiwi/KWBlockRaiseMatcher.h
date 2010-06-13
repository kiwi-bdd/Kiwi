//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"
#import "KWMatcher.h"

#if KW_BLOCKS_ENABLED

@interface KWBlockRaiseMatcher : KWMatcher {
@private
    NSException *exception;
    NSException *actualException;
}

#pragma mark -
#pragma mark Configuring Matchers

- (void)raise;
- (void)raiseWithName:(NSString *)aName;
- (void)raiseWithReason:(NSString *)aReason;
- (void)raiseWithName:(NSString *)aName reason:(NSString *)aReason;

@end

#endif // #if KW_BLOCKS_ENABLED
