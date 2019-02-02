// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Headlines",
    dependencies: [
        .package(path: "../GNews")
    ],
    targets: [
       .target(
            name: "Console", 
            dependencies: []
        ),
        .target(
            name: "Headlines",
            dependencies: ["Console", "GNews"])
    ]
)
