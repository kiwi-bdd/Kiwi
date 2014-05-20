IPHONE32 = -destination 'name=iPhone Retina (4-inch)'
IPHONE64 = -destination 'name=iPhone Retina (4-inch 64-bit)'
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
	@echo "Running 32 bit tests...\n"
	$(XCODEBUILD) $(IPHONE32) -scheme Kiwi -sdk iphonesimulator test | tee xcodebuild.log | xcpretty -c; exit ${PIPESTATUS[0]}
	@echo "\n\n\nRunning 64 bit tests...\n"
	$(XCODEBUILD) $(IPHONE64) -scheme Kiwi -sdk iphonesimulator test | tee xcodebuild.log | xcpretty -c; exit ${PIPESTATUS[0]}

ci: test

