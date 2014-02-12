//
//  KWClassLoading.m
//  Kiwi
//
//  Created by Brian Ivan Gesiak on 2/12/14.
//  Copyright (c) 2014 Allen Ding. All rights reserved.
//

#import "KWClassLoading.h"
#import <objc/runtime.h>

void loadClassesConformingToProtocol(NSMutableArray *destination,
                                     Protocol *protocol) {
    int numberOfClasses = objc_getClassList(NULL, 0);
    Class *classes = (Class *)malloc(sizeof(Class) * numberOfClasses);
    numberOfClasses = objc_getClassList(classes, numberOfClasses);

    if (numberOfClasses == 0) {
        free(classes);
        return;
    }

    for (int i = 0; i < numberOfClasses; ++i) {
        Class candidateClass = classes[i];

        if (!class_respondsToSelector(candidateClass, @selector(conformsToProtocol:)))
            continue;

        if (![candidateClass conformsToProtocol:protocol])
            continue;

        [destination addObject:candidateClass];
    }
    
    free(classes);
}
