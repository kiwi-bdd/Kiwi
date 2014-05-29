SHELL = /bin/bash -e -o pipefail
IPHONE32 = -destination 'name=iPhone Retina (4-inch)'
IPHONE64 = -destination 'name=iPhone Retina (4-inch 64-bit)'
XCODEBUILD = xcodebuild -project Kiwi.xcodeproj -scheme Kiwi -sdk iphonesimulator

default: clean ios

clean:
	xcodebuild clean
	rm -rf output

ios:
	$(XCODEBUILD) -scheme Kiwi-iOS build

install:
	$(XCODEBUILD) -scheme Kiwi-iOS install

test:
	@echo "Running 32 bit tests..."
	$(XCODEBUILD) $(IPHONE32) test | tee xcodebuild.log | xcpretty -c
	#
	@echo "Running 64 bit tests..."
	$(XCODEBUILD) $(IPHONE64) test | tee xcodebuild.log | xcpretty -c

ci: test

