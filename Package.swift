// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "EDNetwork",
    platforms: [
        .iOS(.v15), .macOS(.v12)
    ],
    products: [
        .library(
            name: "EDNetwork",
            targets: ["EDNetwork"])
    ],
    dependencies: [
        .package(url: "https://github.com/Quick/Nimble.git",
                 .upToNextMajor(from: Version(11, 2, 1))),
    ],
    targets: [
        .target(
            name: "EDNetwork",
            dependencies: []),
        .testTarget(
            name: "EDNetworkTests",
            dependencies: ["EDNetwork", "Nimble"]),
    ]
)
