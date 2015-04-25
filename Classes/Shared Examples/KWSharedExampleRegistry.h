//
// Licensed under the terms in License.txt
//
// Copyright 2014 Allen Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KWSharedExample;

@interface KWSharedExampleRegistry : NSObject

+ (instancetype)sharedRegistry;
- (KWSharedExample *)sharedExampleForName:(NSString *)name;
- (void)registerSharedExample:(KWSharedExample *)sharedExample;

@end
