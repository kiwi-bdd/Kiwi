SHELL = /bin/bash -e -o pipefail
IPHONE32 = -scheme Kiwi -sdk iphonesimulator -destination 'name=iPhone 4s'
IPHONE64 = -scheme Kiwi -sdk iphonesimulator -destination 'name=iPhone 6'
MACOSX = -scheme Kiwi-OSX -sdk macosx
XCODEBUILD = xcodebuild -project Kiwi.xcodeproj
DEMO_IOS = -workspace KiwiDemo.xcworkspace -scheme Demo-iOS -destination 'platform=iOS Simulator,name=iPhone 6'
DEMO_OSX =  -workspace KiwiDemo.xcworkspace -scheme Demo-OSX

default: clean ios

clean:
	xcodebuild clean
	rm -rf output

ios:
	$(XCODEBUILD) -scheme Kiwi-iOS build

install:
	$(XCODEBUILD) -scheme Kiwi-iOS install

test: test-iphone32 test-iphone64 test-macosx test-cocoapods

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

test-cocoapods:
	cd Demo && \
	pod install && \
	xcodebuild $(DEMO_IOS) test | xcpretty -c && \
	xcodebuild $(DEMO_OSX) test | xcpretty -c

ci: test
