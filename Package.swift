// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GOOStore",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],    
    products: [
        .library(
            name: "GOOStore",
            targets: ["GOOStore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/goojoob/Utils/", from: "1.1.0")
    ],
    targets: [
        .target(
            name: "GOOStore",
            dependencies: ["Utils"])
    ]
)
