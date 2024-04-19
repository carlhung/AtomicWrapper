// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let swiftSettings: [SwiftSetting] = [.unsafeFlags([ "-strict-concurrency=complete"])]

let package = Package(
    name: "atomicWrapper",
    products: [
        .library(
            name: "atomicWrapper",
            targets: ["atomicWrapper"]),
    ],
    targets: [
        .target(
            name: "atomicWrapper", swiftSettings: swiftSettings),
        .testTarget(
            name: "atomicWrapperTests",
            dependencies: ["atomicWrapper"], swiftSettings: swiftSettings),
    ]
)
