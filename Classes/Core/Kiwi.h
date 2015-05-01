//
// Licensed under the terms in License.txt
//
// Copyright 2010 Allen Ding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>

//! Project version number for Kiwi.
FOUNDATION_EXPORT double KiwiVersionNumber;

//! Project version string for Kiwi.
FOUNDATION_EXPORT const unsigned char KiwiVersionString[];

// This needs to come first.
#import <Kiwi/KiwiConfiguration.h>

#if defined(__cplusplus)
extern "C" {
#endif

#import <Kiwi/KWAfterAllNode.h>
#import <Kiwi/KWAfterEachNode.h>
#import <Kiwi/KWAny.h>
#import <Kiwi/KWAsyncVerifier.h>
#import <Kiwi/KWBeBetweenMatcher.h>
#import <Kiwi/KWBeEmptyMatcher.h>
#import <Kiwi/KWBeIdenticalToMatcher.h>
#import <Kiwi/KWBeKindOfClassMatcher.h>
#import <Kiwi/KWBeMemberOfClassMatcher.h>
#import <Kiwi/KWBeSubclassOfClassMatcher.h>
#import <Kiwi/KWBeTrueMatcher.h>
#import <Kiwi/KWBeWithinMatcher.h>
#import <Kiwi/KWBeZeroMatcher.h>
#import <Kiwi/KWBeforeAllNode.h>
#import <Kiwi/KWBeforeEachNode.h>
#import <Kiwi/KWBlock.h>
#import <Kiwi/KWBlockNode.h>
#import <Kiwi/KWBlockRaiseMatcher.h>
#import <Kiwi/KWCallSite.h>
#import <Kiwi/KWCaptureSpy.h>
#import <Kiwi/KWChangeMatcher.h>
#import <Kiwi/KWConformToProtocolMatcher.h>
#import <Kiwi/KWContainMatcher.h>
#import <Kiwi/KWContainStringMatcher.h>
#import <Kiwi/KWContextNode.h>
#import <Kiwi/KWCountType.h>
#import <Kiwi/KWDeviceInfo.h>
#import <Kiwi/KWEqualMatcher.h>
#import <Kiwi/KWExample.h>
#import <Kiwi/KWExampleDelegate.h>
#import <Kiwi/KWExampleNode.h>
#import <Kiwi/KWExampleNodeVisitor.h>
#import <Kiwi/KWExampleSuiteBuilder.h>
#import <Kiwi/KWExistVerifier.h>
#import <Kiwi/KWExpectationType.h>
#import <Kiwi/KWFailure.h>
#import <Kiwi/KWFormatter.h>
#import <Kiwi/KWFutureObject.h>
#import <Kiwi/KWGenericMatcher.h>
#import <Kiwi/KWHaveMatcher.h>
#import <Kiwi/KWHaveValueMatcher.h>
#import <Kiwi/KWInequalityMatcher.h>
#import <Kiwi/KWInvocationCapturer.h>
#import <Kiwi/KWItNode.h>
#import <Kiwi/KWLet.h>
#import <Kiwi/KWMatchVerifier.h>
#import <Kiwi/KWMatcher.h>
#import <Kiwi/KWMatcherFactory.h>
#import <Kiwi/KWMatchers.h>
#import <Kiwi/KWMatching.h>
#import <Kiwi/KWMessagePattern.h>
#import <Kiwi/KWMessageSpying.h>
#import <Kiwi/KWMock.h>
#import <Kiwi/KWNilMatcher.h>
#import <Kiwi/KWNotificationMatcher.h>
#import <Kiwi/KWNull.h>
#import <Kiwi/KWObjCUtilities.h>
#import <Kiwi/KWPendingNode.h>
#import <Kiwi/KWProbe.h>
#import <Kiwi/KWReceiveMatcher.h>
#import <Kiwi/KWRegisterMatchersNode.h>
#import <Kiwi/KWRegularExpressionPatternMatcher.h>
#import <Kiwi/KWReporting.h>
#import <Kiwi/KWRespondToSelectorMatcher.h>
#import <Kiwi/KWSharedExample.h>
#import <Kiwi/KWSpec.h>
#import <Kiwi/KWStringContainsMatcher.h>
#import <Kiwi/KWStringPrefixMatcher.h>
#import <Kiwi/KWStringUtilities.h>
#import <Kiwi/KWStub.h>
#import <Kiwi/KWSuiteConfigurationBase.h>
#import <Kiwi/KWUserDefinedMatcher.h>
#import <Kiwi/KWValue.h>
#import <Kiwi/KWVerifying.h>

// Public Foundation Categories
#import <Kiwi/NSObject+KiwiMockAdditions.h>
#import <Kiwi/NSObject+KiwiSpyAdditions.h>
#import <Kiwi/NSObject+KiwiStubAdditions.h>
#import <Kiwi/NSObject+KiwiVerifierAdditions.h>
#import <Kiwi/NSProxy+KiwiVerifierAdditions.h>

#import <Kiwi/KiwiMacros.h>

// Some Foundation headers use Kiwi keywords (e.g. 'should') as identifiers for
// parameter names. Including this last allows the use of Kiwi keywords without
// conflicting with these headers (hopefully!).
#import <Kiwi/KiwiBlockMacros.h>

#if defined(__cplusplus)
}
#endif
