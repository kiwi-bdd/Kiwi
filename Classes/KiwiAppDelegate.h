//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KiwiViewController;

@interface KiwiAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    KiwiViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet KiwiViewController *viewController;

@end
