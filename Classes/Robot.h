//
//  Robot.h
//  Kiwi
//
//  Created by Luke Redpath on 17/01/2011.
//  Copyright 2011 Allen Ding. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Robot : NSObject {

}
+ (id)robot;
- (void)speak:(NSString *)message;
- (void)speak:(NSString *)message afterDelay:(NSTimeInterval)delay whenDone:(void(^)(void))handler;
@end
