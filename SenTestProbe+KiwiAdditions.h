//
//  SenTestProbe+KiwiAdditions.h
//  Kiwi
//
//  Created by Jerry Marino on 3/2/13.
//  Copyright (c) 2013 Allen Ding. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <objc/runtime.h>

#define IMPLEMENT_SENTESTPROBE_CATEGORY(actions) \
\
@implementation SenTestProbe (Focus) \
\
+ (void)load { \
actions; \
} \
\
@end

// Only to supress warnings for using private API
@interface SenTestSuite ()

+ (id)emptyTestSuiteNamedFromPath:(id)path;

@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-function"

static inline NSArray *SpecNamesInFile(NSString * path){
    NSRegularExpression *specBeginRegex = [NSRegularExpression regularExpressionWithPattern:@".*(SPEC_BEGIN)\\([a-z]*"
                                                                                    options:NSRegularExpressionAnchorsMatchLines | NSRegularExpressionCaseInsensitive
                                                                                      error:nil];
    NSString *thisFile = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray *matches = [specBeginRegex matchesInString:thisFile
                                               options:0
                                                 range:NSMakeRange(0, [thisFile length])];

    NSMutableArray *names = [NSMutableArray array];
    for (NSTextCheckingResult *match in matches) {
        NSString *classPartial = [thisFile substringWithRange:match.range];
        [names addObject:[classPartial stringByReplacingOccurrencesOfString:@"SPEC_BEGIN(" withString:@""]];
    }
    return names;
}

static inline void SenTestProbeSetSpecfiedTestSuiteForSuiteNames(NSArray *names){
    IMP focusedSuite = imp_implementationWithBlock(^(){
        NSString *path = [[NSBundle bundleForClass:NSClassFromString(names[0])] bundlePath];
        SenTestSuite *suite = [SenTestSuite emptyTestSuiteNamedFromPath:path];
        for(NSString *className in names)
            [suite addTest:[NSClassFromString(className) defaultTestSuite]];
        return suite;
    });
    method_setImplementation(class_getClassMethod(
                                                  [SenTestProbe class],
                                                  @selector(specifiedTestSuite)),
                             focusedSuite);
}

#pragma clang diagnostic pop