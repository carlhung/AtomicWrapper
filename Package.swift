// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let swiftSettings: [SwiftSetting] = [.unsafeFlags([ "-strict-concurrency=complete"])]

let package = Package(
    name: "AtomicWrapper",
    products: [
        .library(
            name: "AtomicWrapper",
            targets: ["AtomicWrapper"]),
    ],
    targets: [
        .target(
            name: "AtomicWrapper", swiftSettings: swiftSettings),
        .testTarget(
            name: "AtomicWrapperTests",
            dependencies: ["AtomicWrapper"], swiftSettings: swiftSettings),
    ]
)
