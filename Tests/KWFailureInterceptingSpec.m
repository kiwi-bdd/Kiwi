#import "KWFailureInterceptingSpec.h"

@interface KWFailureInterceptingSpec ()
@property (nonatomic, readwrite, nullable) KWFailure *failure;
@property (nonatomic, readwrite, getter=isRecording) BOOL recording;
@end

@implementation KWFailureInterceptingSpec

+ (void)buildExampleGroups {
    id _kw_test_case_class = self;
    {
        __unused KWFailureInterceptingSpec *self = _kw_test_case_class;

        KWDefineMatchers(@"haveFailed", ^(KWUserDefinedMatcherBuilder *matcher) {
            [matcher match:^BOOL(id subject) {
                [self whileRecordingFailures:^{
                    [subject call];
                }];
                return self.failure != nil;
            }];

            [matcher failureMessageForShould:^(id subject) {
                return @"expected the block to record a test failure";
            }];

            [matcher failureMessageForShouldNot:^(id subject) {
                // TODO: Incorporate the recorded failure into the failure message
                return @"expected the block not to record a test failure";
            }];
        });
    }
}

- (void)whileRecordingFailures:(void (^)(void))block {
    self.recording = YES;
    block();
    self.recording = NO;
}

- (void)recordFailureWithDescription:(NSString *)description inFile:(NSString *)filePath atLine:(NSUInteger)lineNumber expected:(BOOL)expected {
    if (!self.isRecording) {
        [super recordFailureWithDescription:description inFile:filePath atLine:lineNumber expected:expected];
        return;
    }

    KWCallSite *callSite = [KWCallSite callSiteWithFilename:filePath lineNumber:lineNumber];
    KWFailure *failure = [KWFailure failureWithCallSite:callSite format:description];
    self.failure = failure;
}

- (void)tearDown {
    self.failure = nil;
}

@end
