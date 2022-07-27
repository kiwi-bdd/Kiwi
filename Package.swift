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
            url: "https://github.com/Quick/Nimble", "8.0.0"..<"9.0.0"
        )
    ],
    targets: [
        .target(
            name: "Kiwi",
            cSettings: [
                .headerSearchPath("./**")
            ]
        ),
        .target(
            name: "Test Classes",
            dependencies: [
                "Kiwi"
            ],
            publicHeadersPath: "./",
            cSettings: [
                .headerSearchPath("./../Kiwi/**")
            ]
        ),
        .testTarget(
            name: "KiwiTests",
            dependencies: [
                "Kiwi",
                "Nimble",
                "Test Classes"
            ],
            cSettings: [
                .headerSearchPath("./**"),
                .headerSearchPath("../../Sources/Kiwi/**")
            ]
        ),
        .testTarget(
            name: "KiwiTestsNoArc",
            dependencies: [
                "Kiwi",
                "Test Classes"
            ],
            cSettings: [
                .headerSearchPath("../KiwiTests/**"),
                .headerSearchPath("../../Sources/Kiwi/**"),
                .unsafeFlags(["-fno-objc-arc"])
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
