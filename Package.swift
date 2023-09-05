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
                .headerSearchPath("./"),
                .headerSearchPath("./include/Kiwi"),
                .headerSearchPath("./Config"),
                .headerSearchPath("./Core"),
                .headerSearchPath("./Matchers"),
                .headerSearchPath("./Mocking"),
                .headerSearchPath("./Nodes"),
                .headerSearchPath("./Shared Examples"),
                .headerSearchPath("./Stubbing"),
                .headerSearchPath("./Verifiers"),
            ]
        ),
        .target(
            name: "Test Classes",
            dependencies: [
                "Kiwi"
            ],
            publicHeadersPath: "./",
            cSettings: [
                .headerSearchPath("./"),
                .headerSearchPath("../Kiwi"),
                .headerSearchPath("../Kiwi/include/Kiwi"),
                .headerSearchPath("../Kiwi/Config"),
                .headerSearchPath("../Kiwi/Matchers"),
                .headerSearchPath("../Kiwi/Nodes"),
                .headerSearchPath("../Kiwi/Stubbing"),
                .headerSearchPath("../Kiwi/Core"),
                .headerSearchPath("../Kiwi/Mocking"),
                .headerSearchPath("../Kiwi/Shared Examples"),
                .headerSearchPath("../Kiwi/Verifiers"),
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
                .headerSearchPath("./"),
                .headerSearchPath("../../Sources/Kiwi"),
                .headerSearchPath("../../Sources/Kiwi/include/Kiwi"),
                .headerSearchPath("../../Sources/Kiwi/Config"),
                .headerSearchPath("../../Sources/Kiwi/Matchers"),
                .headerSearchPath("../../Sources/Kiwi/Nodes"),
                .headerSearchPath("../../Sources/Kiwi/Stubbing"),
                .headerSearchPath("../../Sources/Kiwi/Core"),
                .headerSearchPath("../../Sources/Kiwi/Mocking"),
                .headerSearchPath("../../Sources/Kiwi/Shared Examples"),
                .headerSearchPath("../../Sources/Kiwi/Verifiers"),
            ]
        ),
        .testTarget(
            name: "KiwiTestsNoArc",
            dependencies: [
                "Kiwi",
                "Test Classes"
            ],
            cSettings: [
                .headerSearchPath("../KiwiTests"),
                .headerSearchPath("../../Sources/Kiwi"),
                .headerSearchPath("../../Sources/Kiwi/include/Kiwi"),
                .headerSearchPath("../../Sources/Kiwi/Config"),
                .headerSearchPath("../../Sources/Kiwi/Matchers"),
                .headerSearchPath("../../Sources/Kiwi/Nodes"),
                .headerSearchPath("../../Sources/Kiwi/Stubbing"),
                .headerSearchPath("../../Sources/Kiwi/Core"),
                .headerSearchPath("../../Sources/Kiwi/Mocking"),
                .headerSearchPath("../../Sources/Kiwi/Shared Examples"),
                .headerSearchPath("../../Sources/Kiwi/Verifiers"),
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
