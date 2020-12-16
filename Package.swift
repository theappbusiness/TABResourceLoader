// swift-tools-version:5.0

import PackageDescription

/// The name of the entire package
let name = "TABResourceLoader"
let testName = name + "Tests"

/// The platforms this package supports
let supportedPlatforms: [SupportedPlatform] = [.iOS(.v8)]

/// The main target
let mainTarget: Target = .target(
    name: name,
    path: "Sources/" + name
)

/// The test target
let testTarget: Target = .testTarget(
    name: testName,
    dependencies: [.target(name: name)],
    path: "Tests/" + testName
)

/// The final product
let product: Product = .library(name: name, targets: [mainTarget.name])

// The exported package
let package = Package(
    name: name,
    platforms: supportedPlatforms,
    products: [product],
    targets: [mainTarget, testTarget]
)
