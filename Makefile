SHELL = /bin/bash -e -o pipefail
IPHONE32 = -scheme Kiwi -sdk iphonesimulator -destination 'name=iPhone Retina (4-inch)'
IPHONE64 = -scheme Kiwi -sdk iphonesimulator -destination 'name=iPhone Retina (4-inch 64-bit)'
MACOSX = -scheme Kiwi-OSX -sdk macosx
XCODEBUILD = xcodebuild -project Kiwi.xcodeproj

default: clean ios

clean:
	xcodebuild clean
	rm -rf output

ios:
	$(XCODEBUILD) -scheme Kiwi-iOS build

install:
	$(XCODEBUILD) -scheme Kiwi-iOS install

test:
	@echo "Running 32 bit iPhone tests..."
	$(XCODEBUILD) $(IPHONE32) test | tee xcodebuild.log | xcpretty -c
	#
	@echo "Running 64 bit iPhone tests..."
	$(XCODEBUILD) $(IPHONE64) test | tee xcodebuild.log | xcpretty -c
	#
	@echo "Running 32 bit OS X tests..."
	$(XCODEBUILD) $(MACOSX) test | tee xcodebuild.log | xcpretty -c

ci: test

