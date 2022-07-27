// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Kiwi",
    platforms: [
        .iOS(.v9),
        .macOS(.v10_10)
    ],
    products: [
        .library(name: "Kiwi", targets: ["Kiwi"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/Quick/Nimble", from: "10.0.0"
        )
    ],
    targets: [
        .target(
            name: "Kiwi",
            cSettings: [
                .headerSearchPath("./**")
            ]
        ),
        .testTarget(
            name: "KiwiTests",
            dependencies: [
                "Kiwi",
                "Nimble"
            ],
            cSettings: [
                .headerSearchPath("./**"),
                .headerSearchPath("../../Sources/Kiwi/**")
            ]
        ),
        .testTarget(
            name: "KiwiTestsSwift",
            dependencies: [
                "Kiwi",
                "Nimble"
            ]
        )
    ]
)
