default: clean ios

clean:
	xcodebuild clean
	rm -rf output

ios:
	xcodebuild -project Kiwi.xcodeproj -scheme Kiwi-iOS build

install:
	xcodebuild -project Kiwi.xcodeproj -scheme Kiwi-iOS install