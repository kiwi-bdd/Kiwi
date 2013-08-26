//
//  KWLetNode.h
//  Kiwi
//
//  Created by Adam Sharp on 27/08/13.
//  Copyright (c) 2013 Allen Ding. All rights reserved.
//

#import "KiwiConfiguration.h"
#import "KWExampleNode.h"

@interface KWLetNode : NSObject

- (instancetype)initWithSymbolName:(NSString *)aSymbolName objectRef:(id *)anObjectRef block:(id (^)(void))block;
+ (instancetype)letNodeWithSymbolName:(NSString *)aSymbolName objectRef:(id *)anObjectRef block:(id (^)(void))block;

@property (nonatomic, copy) NSString *symbolName;
@property (nonatomic, copy) id (^block)(void);
@property (nonatomic, readonly) NSValue *objectRef;

- (id)evaluate;

@end
