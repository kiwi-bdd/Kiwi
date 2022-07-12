// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Kiwi",
    platforms: [
        .iOS(.v8),
        .macOS(.v10_10)
    ],
    products: [
        .library(name: "Kiwi", targets: ["Kiwi"])
    ],
    targets: [
        .target(
            name: "Kiwi",
            path: "Classes",
            cSettings: [
                .headerSearchPath("./**")
            ]
        )
    ]
)
