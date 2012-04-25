//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

// This needs to come first.
#import "KiwiConfiguration.h"
#import <SenTestingKit/SenTestingKit.h>

#if defined(__cplusplus)
extern "C" {
#endif

#import "KWAfterAllNode.h"
#import "KWAfterEachNode.h"
#import "KWAny.h"
#import "KWAsyncVerifier.h"
#import "KWBeBetweenMatcher.h"
#import "KWBeEmptyMatcher.h"
#import "KWBeIdenticalToMatcher.h"
#import "KWBeKindOfClassMatcher.h"
#import "KWBeMemberOfClassMatcher.h"
#import "KWBeSubclassOfClassMatcher.h"
#import "KWBeTrueMatcher.h"
#import "KWBeNilMatcher.h"
#import "KWBeNonNilMatcher.h"
#import "KWBeWithinMatcher.h"
#import "KWBeZeroMatcher.h"
#import "KWBeforeAllNode.h"
#import "KWBeforeEachNode.h"
#import "KWBlock.h"
#import "KWBlockNode.h"
#import "KWBlockRaiseMatcher.h"
#import "KWCallSite.h"
#import "KWConformToProtocolMatcher.h"
#import "KWContainMatcher.h"
#import "KWContextNode.h"
#import "KWDeviceInfo.h"
#import "KWEqualMatcher.h"
#import "KWExample.h"
#import "KWExampleGroupBuilder.h"
#import "KWExampleNode.h"
#import "KWExampleNodeVisitor.h"
#import "KWExistVerifier.h"
#import "KWExpectationType.h"
#import "KWFailure.h"
#import "KWFormatter.h"
#import "KWFutureObject.h"
#import "KWHamcrestMatcher.h"
#import "KWHaveMatcher.h"
#import "KWHaveValueMatcher.h"
#import "KWInequalityMatcher.h"
#import "KWInvocationCapturer.h"
#import "KWItNode.h"
#import "KWMatchVerifier.h"
#import "KWMatcher.h"
#import "KWMatchers.h"
#import "KWMatcherFactory.h"
#import "KWMatching.h"
#import "KWMessagePattern.h"
#import "KWMessageSpying.h"
#import "KWMock.h"
#import "KWNull.h"
#import "KWObjCUtilities.h"
#import "KWPendingNode.h"
#import "KWRaiseMatcher.h"
#import "KWReceiveMatcher.h"
#import "KWRegisterMatchersNode.h"
#import "KWRespondToSelectorMatcher.h"
#import "KWSpec.h"
#import "KWStringUtilities.h"
#import "KWStub.h"
#import "KWTestCase.h"
#import "KWUserDefinedMatcher.h"
#import "KWValue.h"
#import "KWVerifying.h"
#import "KWCaptureSpy.h"
    
// Public Foundation Categories
#import "NSObject+KiwiMockAdditions.h"
#import "NSObject+KiwiStubAdditions.h"
#import "NSObject+KiwiVerifierAdditions.h"

#import "KiwiMacros.h"

// Some Foundation headers use Kiwi keywords (e.g. 'should') as identifiers for
// parameter names. Including this last allows the use of Kiwi keywords without
// conflicting with these headers (hopefully!).
#import "KiwiBlockMacros.h"

#if defined(__cplusplus)
}
#endif

