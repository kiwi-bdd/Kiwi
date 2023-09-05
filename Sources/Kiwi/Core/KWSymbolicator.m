//
//  KWSymbolicator.m
//  Kiwi
//
//  Created by Jerry Marino on 4/28/13.
//  Copyright (c) 2013 Allen Ding. All rights reserved.
//

#import <objc/runtime.h>
#import <libunwind.h>
#import <mach-o/dyld.h>
#import "KWSymbolicator.h"
#import "KWBackgroundTask.h"

long kwCallerAddress (void){
#if !__arm__
	unw_cursor_t cursor; unw_context_t uc;
	unw_word_t ip;

	unw_getcontext(&uc);
	unw_init_local(&cursor, &uc);

    int pos = 2;
	while (unw_step(&cursor) && pos--){
		unw_get_reg (&cursor, UNW_REG_IP, &ip);
        if(pos == 0) return (NSUInteger)(ip - 4);
	}
#endif
    return 0;
}

@implementation KWCallSite (KWSymbolication)

static void GetTestBundleExecutablePathSlide(NSString **executablePath, long *slide) {
    for (int i = 0; i < _dyld_image_count(); i++) {
        if (strstr(_dyld_get_image_name(i), ".octest/") || strstr(_dyld_get_image_name(i), ".xctest/")) {
            *executablePath = [NSString stringWithUTF8String:_dyld_get_image_name(i)];
            *slide = _dyld_get_image_vmaddr_slide(i);
            break;
        }
    }
}

+ (KWCallSite *)callSiteWithCallerAddress:(long)address {
    // Symbolicate the address with atos to get the line number & filename.
    // If the command raises, no specs will run so don't bother catching
    // In the case of a non 0 exit code, failure to launch, or timeout, the
    // user will atleast have an idea of why the task failed.

    long slide;
    NSString *executablePath;
    GetTestBundleExecutablePathSlide(&executablePath, &slide);
    NSArray *arguments = @[@"-o", executablePath, @"-s", [NSString stringWithFormat:@"%lx", slide], [NSString stringWithFormat:@"%lx", address]];

    // See atos man page for more information on arguments.
    KWBackgroundTask *symbolicationTask = [[KWBackgroundTask alloc] initWithCommand:@"/usr/bin/atos" arguments:arguments];
    [symbolicationTask launchAndWaitForExit];

    NSString *symbolicatedCallerAddress = [[NSString alloc] initWithData:symbolicationTask.output encoding:NSUTF8StringEncoding];

    NSString *pattern = @".+\\((.+):([0-9]+)\\)";
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    NSArray *matches = [regex matchesInString:symbolicatedCallerAddress options:0 range:NSMakeRange(0, symbolicatedCallerAddress.length)];

    NSString *fileName;
    NSInteger lineNumber = 0;

    for (NSTextCheckingResult *ntcr in matches) {
        fileName = [symbolicatedCallerAddress substringWithRange:[ntcr rangeAtIndex:1]];
        NSString *lineNumberMatch = [symbolicatedCallerAddress substringWithRange:[ntcr rangeAtIndex:2]];
        lineNumber = lineNumberMatch.integerValue;
    }
    return [KWCallSite callSiteWithFilename:fileName lineNumber:lineNumber];
}

@end
