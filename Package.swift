// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package: Package = .init(
    name: "trash",
    platforms: [.macOS(.v10_15)],
    products: [
        .executable(name: "trash", targets: ["trash"])
    ],
    targets: [
        .executableTarget(name: "trash")
    ]
)
