// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OPPlayer",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "OPPlayer",
            targets: [
                "OPPlayer"
            ]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "OPPlayer",
            dependencies: [
                "OPPlayerObjC"
            ]
        ),
        .target(
            name: "OPPlayerObjC",
            dependencies: [
            ],
            path: "Sources/OPPlayerObjC",
            publicHeadersPath: "."
        ),
        .target(
            name: "OPPlayerUI",
            dependencies: [
                "OPPlayerObjC"
            ]
        ),
        .testTarget(
            name: "OPPlayerTests",
            dependencies: [
                "OPPlayer"
            ]
        ),
    ]
)
