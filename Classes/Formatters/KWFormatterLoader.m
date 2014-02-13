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

@implementation KWFormatterLoader

+ (NSArray *)formatters {
    NSOrderedSet *specifiedFormatters = [self formatterNamesInPlist];
    if ([specifiedFormatters count] == 0) {
        return [self defaultFormatters];
    } else {
        NSMutableArray *listenerClasses = [NSMutableArray array];
        loadClassesConformingToProtocol(listenerClasses, @protocol(KWListener));

        NSMutableArray *formatters = [NSMutableArray array];
        for (Class listenerClass in listenerClasses) {
            if ([specifiedFormatters containsObject:NSStringFromClass(listenerClass)]) {
                [formatters addObject:[listenerClass new]];
            }
        }

        if ([formatters count] == 0) {
            return [self defaultFormatters];
        } else {
            return formatters;
        }
    }
}

#pragma mark - Internal Methods

+ (NSOrderedSet *)formatterNamesInPlist {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:kKWConfigurationPlistName ofType:@"plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        return nil;
    }

    NSDictionary *plistDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    return [NSOrderedSet orderedSetWithArray:[plistDictionary objectForKey:@"formatters"]];
}

+ (NSArray *)defaultFormatters {
    return @[[KWTextFormatter new]];
}

@end
