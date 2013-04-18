//
// Created by rael on 16/04/2013.
//

#import <Foundation/Foundation.h>
#import <Kiwi/KWBlock.h>
#import "KWStep.h"



id exec(NSObject <KWStep> *target, SEL selector, id object2) {
    assert([target respondsToSelector:selector]);

    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    __block id returnVal;
    KWStepBlock aBlock = ^(id val){
        dispatch_semaphore_signal(semaphore);
        returnVal = val;
    };

    if (object2){
        [target performSelector:selector withObject:aBlock withObject:object2];
    } else {
        [target performSelector:selector withObject:aBlock];
    }

    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];

    return returnVal;
}

void stepAndWait(NSObject <KWStep> *target, SEL selector, id object2) {
    assert([target respondsToSelector:selector]);

    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    id aBlock = ^{ dispatch_semaphore_signal(semaphore);};

    if (object2){
        [target performSelector:selector withObject:aBlock withObject:object2];
    } else {
        [target performSelector:selector withObject:aBlock];
    }

    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW))
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}