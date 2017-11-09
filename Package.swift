// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TABResourceLoader",
    products: [
        .library(
            name: "TABResourceLoader",
            targets: ["TABResourceLoader"]),
    ],
    targets: [
        .target(
            name: "TABResourceLoader",
            dependencies: []),
    ]
)
