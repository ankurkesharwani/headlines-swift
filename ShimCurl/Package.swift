// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ShimCurl",
    products: [
        .library(
            name: "ShimCurl",
            targets: ["ShimCurl"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "ShimCurl", 
            dependencies: ["CCurl"]
        ),
        .systemLibrary(
            name: "CCurl", 
            path: "Sources/CCurl/include", 
            pkgConfig: "libcurl", 
            providers: [
                .brew(["curl"]),
                .apt(["curl"])
            ])
    ]
)
