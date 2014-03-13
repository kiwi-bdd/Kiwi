//
//  KWFutureInstanceAttacher.h
//  Kiwi
//
//  Created by Jerry Marino on 3/12/14.
//  Copyright (c) 2014 Allen Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KWVerifying.h" 

@class KWExample;
@class KWMatcherFactory;

@protocol KWMatching;

@interface KWFutureInstanceAttacher : NSObject <KWVerifying>

@property (nonatomic, strong) KWCallSite *callSite;
@property (nonatomic, assign) Class instanceClass;

//TODO (JM) : write some unit tests
- (id)attachToVerifier:(id<KWVerifying>)aVerifier;
- (void)addInstance:(id)anInstance;

@end

@interface NSObject (KWAnyInstanceSupport)

void KWClearFutureInstanceAttachment(void);

+ (id)anyInstance;

@end
