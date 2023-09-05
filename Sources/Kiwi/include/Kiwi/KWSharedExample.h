//
// Licensed under the terms in License.txt
//
// Copyright 2014 Allen Ding. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^KWSharedExampleBlock)(NSDictionary *data);

@interface KWSharedExample : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) KWSharedExampleBlock block;

- (id)initWithName:(NSString *)name block:(KWSharedExampleBlock)block;

@end

#pragma mark - Building Shared Example Groups

void sharedExamplesFor(NSString *name, KWSharedExampleBlock block);
void itBehavesLike(NSString *name, NSDictionary *data);
