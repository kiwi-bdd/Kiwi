//
// Licensed under the terms in License.txt
//
// Copyright 2014 Allen Ding. All rights reserved.
//

#import "KWFormatterLoader.h"
#import "KWClassLoading.h"
#import "KWListener.h"
#import "KWTextFormatter.h"

static NSString * const kKWConfigurationPlistName = @"KiwiConfiguration";
static NSString * const kKWConfigurationPlistFormattersKey = @"formatters";

@implementation KWFormatterLoader

+ (NSArray *)formatters {
    NSDictionary *formatterMappings = [self formatterMappingsFromPlist:kKWConfigurationPlistName];
    if ([formatterMappings count] == 0) {
        return [self defaultFormatters];
    }

    Protocol *listenerProtocol = @protocol(KWListener);
    NSDictionary *listeners = [self classesForProtocol:listenerProtocol];

    NSMutableArray *formatters = [NSMutableArray array];
    for (NSString *formatterName in [formatterMappings keyEnumerator]) {
        Class listenerClass = listeners[formatterName];
        if (!listenerClass) {
            [NSException raise:NSInternalInconsistencyException
                        format:@"Could not find a class called '%@' that conforms to the "
                               @"%@ protocol. If '%@' is a custom formatter classs, are you sure "
                               @"it's included in your test bundle? If it's a Kiwi class, are you "
                               @"sure it's spelled correctly?",
                               formatterName, formatterName, listenerProtocol];
        }

        NSString *path = formatterMappings[formatterName];
        NSFileHandle *fileHandle = [self fileHandleForPath:path];
        KWBaseFormatter *formatter = [[listenerClass alloc] initWithFileHandle:fileHandle];
        [formatters addObject:formatter];
    }

    if ([formatters count] == 0) {
        return [self defaultFormatters];
    } else {
        return formatters;
    }
}

#pragma mark - Internal Methods

+ (NSDictionary *)formatterMappingsFromPlist:(NSString *)plistName {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:plistName ofType:@"plist"];
    NSDictionary *plistDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    return plistDictionary[kKWConfigurationPlistFormattersKey];
}

+ (NSDictionary *)classesForProtocol:(Protocol *)protocol {
    NSMutableArray *classes = [NSMutableArray array];
    loadClassesConformingToProtocol(classes, protocol);

    NSMutableDictionary *classesForProtocol = [NSMutableDictionary dictionary];
    for (Class cls in classes) {
        classesForProtocol[NSStringFromClass(cls)] = cls;
    }

    return [classesForProtocol copy];
}

+ (NSFileHandle *)fileHandleForPath:(NSString *)path {
    if ([path isEqualToString:@"stdout"]) {
        return [NSFileHandle fileHandleWithStandardOutput];
    } else if ([path isEqualToString:@"stderr"]) {
        return [NSFileHandle fileHandleWithStandardError];
    } else {
        BOOL fileCreated = [[NSFileManager defaultManager] createFileAtPath:path
                                                                   contents:nil
                                                                 attributes:nil];
        if (!fileCreated) {
            [NSException raise:NSInternalInconsistencyException
                        format:@"Could not create file at path: '%@'. "
                               @"Are you sure you specified a full path to a directory "
                               @"that exists and you have permissions to write to?", path];
        }

        return [NSFileHandle fileHandleForWritingAtPath:path];
    }
}

+ (NSArray *)defaultFormatters {
    return @[[KWTextFormatter new]];
}

@end
