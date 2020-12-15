// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "QuickObserver3",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(
            name: "QuickObserver3",
            type: .dynamic,
            targets: ["QuickObserver3"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "QuickObserver3",
            dependencies: []),
        .testTarget(
            name: "QuickObserver3Tests",
            dependencies: ["QuickObserver3"]),
    ]
)
