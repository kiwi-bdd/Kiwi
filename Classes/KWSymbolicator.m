//
//  KWSymbolicator.m
//  Kiwi
//
//  Created by Jerry Marino on 4/28/13.
//  Copyright (c) 2013 Allen Ding. All rights reserved.
//

#import "KWSymbolicator.h"
#import <objc/runtime.h>
#import <libunwind.h>

long kwCallerAddress (void){
	unw_cursor_t cursor; unw_context_t uc;
	unw_word_t ip;

	unw_getcontext(&uc);
	unw_init_local(&cursor, &uc);

    int pos = 2;
	while (unw_step(&cursor) && pos--){
		unw_get_reg (&cursor, UNW_REG_IP, &ip);
        if(pos == 0) return (NSUInteger)(ip - 4);
	}
    return 0;
}

@implementation NSString (KWShellCommand)

+ (NSString *)stringWithShellCommand:(NSString *)command arguments:(NSArray *)arguments {
    id task = [[NSClassFromString(@"NSTask") alloc] init];
    [task performSelector:@selector(setEnvironment:) withObject:[NSDictionary dictionary]];
    [task performSelector:@selector(setLaunchPath:) withObject:command];
    [task performSelector:@selector(setArguments:) withObject:arguments];

    NSPipe *pipe = [NSPipe pipe];
    [task performSelector:@selector(setStandardOutput:) withObject:pipe];
    [task performSelector:@selector(launch)];
    [task performSelector:@selector(waitUntilExit)];

    NSData *data = [[pipe fileHandleForReading] readDataToEndOfFile];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

    return string;
}

@end
