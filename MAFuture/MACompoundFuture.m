#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#import "MAFuture.h"
#import "MAFutureInternal.h"
#import "MAMethodSignatureCache.h"
#import "MACompoundFuture.h"


#define ENABLE_LOGGING 0

#if ENABLE_LOGGING
#define LOG(...) NSLog(__VA_ARGS__)
#else
#define LOG(...)
#endif


@interface _MACompoundFuture : _MALazyBlockFuture
{
}
@end

@implementation _MACompoundFuture

- (BOOL)_canFutureSelector: (SEL)sel
{
    NSMethodSignature *sig = [[MAMethodSignatureCache sharedCache] cachedMethodSignatureForSelector: sel];
    
    if(!sig) return NO;
    else if([sig methodReturnType][0] != @encode(id)[0]) return NO;
    
    // it exists, returns an object, but does it return any non-objects by reference?
    NSUInteger num = [sig numberOfArguments];
    for(NSUInteger i = 2; i < num; i++)
    {
        const char *type = [sig getArgumentTypeAtIndex: i];
        
        // if it's a pointer to a non-object, bail out
        if(type[0] == '^' && type[1] != '@')
            return NO;
    }
    // we survived this far, all is well
    return YES;
}

- (id)forwardingTargetForSelector: (SEL)sel
{
    LOG(@"forwardingTargetForSelector: %p %@", self, NSStringFromSelector(sel));
    
    id value = [self futureValue];
    if(value)
        return value;
    else if([self _canFutureSelector: sel])
        return nil;
    else
        return [self resolveFuture];
}

- (NSMethodSignature *)methodSignatureForSelector: (SEL)sel
{
    LOG(@"methodSignatureForSelector: %p %@", self, NSStringFromSelector(sel));
    
    NSMethodSignature *sig = [[self futureValue] methodSignatureForSelector: sel];
    
    if(!sig)
        sig = [[MAMethodSignatureCache sharedCache] cachedMethodSignatureForSelector: sel];
    
    if(!sig)
        sig = [[self resolveFuture] methodSignatureForSelector: sel];
    
    return sig;
}

- (void)forwardInvocation: (NSInvocation *)invocation
{
    LOG(@"forwardInvocation: %p %@", self, NSStringFromSelector([invocation selector]));
    
    [_lock lock];
    id value = _value;
    BOOL resolved = _resolved;
    [_lock unlock];
    
    if(resolved)
    {
        LOG(@"forwardInvocation: %p forwarding to %p", invocation, value);
        [invocation invokeWithTarget: value];
    }
    else
    {
        // look for return-by-reference objects
        _MALazyBlockFuture *invocationFuture = nil;
        NSMutableArray *parameterDatas = nil;
        NSMethodSignature *sig = [invocation methodSignature];
        NSUInteger num = [sig numberOfArguments];
        for(NSUInteger i = 2; i < num; i++)
        {
            const char *type = [sig getArgumentTypeAtIndex: i];
            if(type[0] == '^' && type[1] == '@')
            {
                // get the existing pointer-to-object
                id *parameterValue;
                [invocation getArgument: &parameterValue atIndex: i];
                
                // if it's NULL, then we don't need to do anything
                if(parameterValue)
                {
                    LOG(@"forwardInvocation: %p found return-by-reference object at argument index %u", self, i);
                    
                    // allocate space to receive the final computed value
                    NSMutableData *newParameterSpace = [NSMutableData dataWithLength: sizeof(id)];
                    id *newParameterValue = [newParameterSpace mutableBytes];
                    
                    // set the parameter to point to the new space
                    [invocation setArgument: &newParameterValue atIndex: i];
                    
                    // create a future to refer to the invocation, so that it
                    // only gets invoked once no matter how many
                    // compound futures reference it
                    if(!invocationFuture)
                    {
                        parameterDatas = [NSMutableArray array];
                        invocationFuture = [[_MALazyBlockFuture alloc] initWithBlock: ^{
                            [invocation invokeWithTarget: [self resolveFuture]];
                            // keep all parameter datas alive until the invocation is resolved
                            // by capturing the variable
                            [parameterDatas self];
                            return (id)nil;
                        }];
                        [invocationFuture autorelease];
                    }
                    [parameterDatas addObject: newParameterSpace];
                    
                    // create the compound future that we'll "return" in this argument
                    _MACompoundFuture *parameterFuture = [[_MACompoundFuture alloc] initWithBlock: ^{
                        [invocationFuture resolveFuture];
                        // capture the NSMutableData to ensure that it stays live
                        // interior pointer problem
                        [newParameterSpace self];
                        return *newParameterValue;
                    }];
                    
                    // and now "return" it
                    *parameterValue = parameterFuture;
                    
                    // memory management
                    [parameterFuture autorelease];
                }
            }
        }
        
        [invocation retainArguments];
        _MACompoundFuture *returnFuture = [[_MACompoundFuture alloc] initWithBlock:^{
            id value = nil;
            if(invocationFuture)
                [invocationFuture resolveFuture];
            else
                [invocation invokeWithTarget: [self resolveFuture]];
            [invocation getReturnValue: &value];
            return value;
        }];
        LOG(@"forwardInvocation: %p creating new compound future %p", invocation, returnFuture);
        [invocation setReturnValue: &returnFuture];
        [returnFuture release];
    }
}

@end

#undef MACompoundBackgroundFuture
id MACompoundBackgroundFuture(id (^block)(void))
{
    id blockFuture = MABackgroundFuture(block);
    
    _MACompoundFuture *compoundFuture = [[_MACompoundFuture alloc] initWithBlock: ^{
        return [blockFuture resolveFuture];
    }];
    
    return [compoundFuture autorelease];
}

#undef MACompoundLazyFuture
id MACompoundLazyFuture(id (^block)(void))
{
    _MACompoundFuture *compoundFuture = [[_MACompoundFuture alloc] initWithBlock: block];
    
    return [compoundFuture autorelease];
}
