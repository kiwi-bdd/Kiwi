//
// Licensed under the terms in License.txt
//
// Copyright 2014 Allen Ding. All rights reserved.
//

#import "KWBaseFormatter.h"

@interface KWBaseFormatter ()
@property (nonatomic, strong) NSFileHandle *fileHandle;
@end

@implementation KWBaseFormatter

#pragma mark - Initializing

- (id)init {
    return [self initWithFileHandle:[NSFileHandle fileHandleWithStandardError]];
}

- (id)initWithFileHandle:(NSFileHandle *)fileHandle {
    self = [super init];
    if (self) {
        _fileHandle = fileHandle;
    }
    return self;
}

- (void)dealloc {
    [_fileHandle closeFile];
}

- (void)log:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSString *string = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    string = [string stringByAppendingString:@"\n"];

    [self.fileHandle writeData:[string dataUsingEncoding:NSASCIIStringEncoding]];
}

@end
