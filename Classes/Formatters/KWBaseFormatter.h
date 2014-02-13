//
// Licensed under the terms in License.txt
//
// Copyright 2014 Allen Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KWListener.h"

@interface KWBaseFormatter : NSObject <KWListener>

@property (nonatomic, strong, readonly) NSFileHandle *fileHandle;

- (id)initWithFileHandle:(NSFileHandle *)fileHandle;
- (void)log:(NSString *)format, ...;

@end
