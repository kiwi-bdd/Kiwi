#import <Kiwi/Kiwi.h>

// Custom spec class that is capable of intercepting test failures before
// XCTest records them. Test failures are not recorded by default, see
// `-whileRecordingTestFailures:`.
@interface KWFailureInterceptingSpec : KWSpec

// Pass a block to be executed while recording test failures.
- (void)whileRecordingFailures:(nonnull void (^)(void))block;

// If a test failure is recorded, this property will be set to the recorded
// failure. The intercepted failure will be set to `nil` after the end of a
// test case run in the spec's `-tearDown` method.
@property (nonatomic, readonly, nullable) KWFailure *failure;

@end

// When using `KWFailureInterceptingSpec`, this matcher enables assertions on
// recorded test failures. Only compatible with a `KWBlock` matcher subject.
registerMatcher(haveFailed);
