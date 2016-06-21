SHELL = /bin/bash -e -o pipefail
IPHONE32 = -scheme Kiwi-iOS -destination 'platform=iOS Simulator,name=iPhone 5'
IPHONE64 = -scheme Kiwi-iOS -destination 'platform=iOS Simulator,name=iPhone 6'
MACOSX = -scheme Kiwi-OSX -destination 'generic/platform=OS X'
XCODEBUILD = xcodebuild -project Kiwi.xcodeproj

default: clean ios

bootstrap:
	carthage bootstrap --no-use-binaries --platform iphoneos,macosx

clean:
	xcodebuild clean

ios:
	$(XCODEBUILD) -scheme Kiwi-iOS build

test: test-iphone32 test-iphone64 test-macosx

test-iphone32:
	@echo "Running 32 bit iPhone tests..."
	$(XCODEBUILD) $(IPHONE32) test | tee xcodebuild.log | xcpretty -c
	ruby test_suite_configuration.rb xcodebuild.log

test-iphone64:
	@echo "Running 64 bit iPhone tests..."
	$(XCODEBUILD) $(IPHONE64) test | tee xcodebuild.log | xcpretty -c
	ruby test_suite_configuration.rb xcodebuild.log

test-macosx:
	@echo "Running OS X tests..."
	$(XCODEBUILD) $(MACOSX) test | tee xcodebuild.log | xcpretty -c
	ruby test_suite_configuration.rb xcodebuild.log

pod-lint-library:
	pod lib lint --use-libraries

pod-lint-framework:
	pod lib lint

ci: bootstrap test-iphone32 test-iphone64 test-macosx pod-lint-library pod-lint-framework
