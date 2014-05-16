TEST_SDK?="iphonesimulator"

default: clean ios

clean:
	xcodebuild clean
	rm -rf output

ios:
	xcodebuild -project Kiwi.xcodeproj -scheme Kiwi-iOS build

install:
	xcodebuild -project Kiwi.xcodeproj -scheme Kiwi-iOS install

test:
	xcodebuild -project Kiwi.xcodeproj -scheme Kiwi -sdk $(TEST_SDK) test

ci: test

