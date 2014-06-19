//
//  Robot.m
//  Kiwi
//
//  Created by Luke Redpath on 17/01/2011.
//  Copyright 2011 Allen Ding. All rights reserved.
//

#import "Robot.h"


@implementation Robot

+ (id)robot; {
    return [[[self alloc] init] autorelease];
}

- (void)speak:(NSString *)message {
    NSLog(@"Robot says %@", message);
}

- (void)speak:(id)message ofType:(Class)messageType {
	NSLog(@"Robot says %@ [Message Type:%@]", message, messageType);
}

- (void)speak:(NSString *)message afterDelay:(NSTimeInterval)delay whenDone:(void(^)(void))handler {
    NSLog(@"Robot will say %@ after a %f second delay", message, delay);
}

- (void)speakURL:(NSURL *)url {
    [self speak:[url absoluteString]];
}

- (void)phoneHome:(void (^)(void))callback {
    [self contactBaseServerAtPath:@"api/v2/robots/phone_home"
                       parameters:@{ @"user_agent" : @"AppleRobot/537.36 (KHTML, like Gecko)" }
                        operation:nil
                         callback:callback
                 responseEncoding:RobotServerResponseEncodingJSON
                    requestMethod:RobotServerRequestMethodPOST
                       httpClient:nil];
}

- (void)contactBaseServerAtPath:(NSString *)path
                     parameters:(NSDictionary *)parameters
                      operation:(NSString *)operation
                       callback:(void (^)(void))callback
               responseEncoding:(RobotServerResponseEncoding)reponseEncoding
                  requestMethod:(RobotServerRequestMethod)requestMethod
                     httpClient:(id)httpClient {
    [self speakURL:[NSURL URLWithString:@"http://robotsanonymous.io"]];
}

@end
