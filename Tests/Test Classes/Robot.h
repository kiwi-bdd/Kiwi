//
//  Robot.h
//  Kiwi
//
//  Created by Luke Redpath on 17/01/2011.
//  Copyright 2011 Allen Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RobotServerResponseEncoding) {
    RobotServerResponseEncodingJSON = 1,
    RobotServerResponseEncodingXML
};

typedef NS_ENUM(NSInteger, RobotServerRequestMethod) {
    RobotServerRequestMethodGET = 1,
    RobotServerRequestMethodPOST,
    RobotServerRequestMethodPUT,
    RobotServerRequestMethodDELETE,
};

@interface Robot : NSObject

+ (id)robot;
- (void)speak:(NSString *)message;
- (void)speak:(id)message ofType:(Class)messageType;
- (void)speak:(NSString *)message afterDelay:(NSTimeInterval)delay whenDone:(void(^)(void))handler;
- (void)speakURL:(NSURL *)url;
- (void)phoneHome:(void (^)(void))callback;
- (void)contactBaseServerAtPath:(NSString *)path
                     parameters:(NSDictionary *)parameters
                      operation:(NSString *)operation
                       callback:(void (^)(void))callback
               responseEncoding:(RobotServerResponseEncoding)reponseEncoding
                  requestMethod:(RobotServerRequestMethod)requestMethod
                     httpClient:(id)httpClient;

@end
