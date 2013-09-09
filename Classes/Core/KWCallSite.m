//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import "KWCallSite.h"

@implementation KWCallSite

#pragma mark - Initializing

- (instancetype)initWithFileName:(NSString *)fileName lineNumber:(NSUInteger)lineNumber {
    self = [super init];
    if (self) {
        _fileName = fileName;
        _lineNumber = lineNumber;
    }
    return self;
}

- (instancetype)initWithPath:(NSString *)path lineNumber:(NSUInteger)lineNumber {
    self = [super init];
    if (self) {
        _path = [path copy];
        NSString *fileName = [[path componentsSeparatedByString:@"/"] lastObject];
        _fileName = fileName;
        _lineNumber = lineNumber;
    }
    return self;
}

+ (instancetype)callSiteWithPath:(NSString *)path lineNumber:(NSUInteger)lineNumber {
    return [[self alloc] initWithPath:path lineNumber:lineNumber];
}

+ (instancetype)callSiteWithFileName:(NSString *)fileName lineNumber:(NSUInteger)lineNumber {
    return [[self alloc] initWithFileName:fileName lineNumber:lineNumber];
}

#pragma mark - Identifying and Comparing

- (NSString *)description {
    return [NSString stringWithFormat:@"%@:%d", self.fileName, self.lineNumber];
}

- (NSUInteger)hash {
    return [[NSString stringWithFormat:@"%@%u", self.fileName, (unsigned)self.lineNumber] hash];
}

- (BOOL)isEqual:(id)anObject {
    if (![anObject isKindOfClass:[KWCallSite class]])
        return NO;

    return [self isEqualToCallSite:anObject];
}

- (BOOL)isEqualToCallSite:(KWCallSite *)aCallSite {
    return [self.fileName isEqualToString:aCallSite.fileName] && (self.lineNumber == aCallSite.lineNumber);
}

@end
