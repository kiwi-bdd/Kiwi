default: clean ios

clean:
	xcodebuild clean

ios:
	xcodebuild -project Kiwi.xcodeproj -scheme Kiwi-iOS build
