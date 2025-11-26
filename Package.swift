// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NativeWebView",
    platforms: [
        .iOS(.v18),
        .macOS(.v15)
    ],
    products: [
        .library(
            name: "NativeWebView",
            targets: ["NativeWebView"]
        ),
        .executable(
            name: "NativeWebViewDemo",
            targets: ["NativeWebViewDemo"]
        )
    ],
    targets: [
        .target(
            name: "NativeWebView",
            dependencies: [],
            path: "Sources/NativeWebView"
        ),
        .executableTarget(
            name: "NativeWebViewDemo",
            dependencies: ["NativeWebView"],
            path: "Example/NativeWebViewDemo"
        ),
        .testTarget(
            name: "NativeWebViewTests",
            dependencies: ["NativeWebView"],
            path: "Tests/NativeWebViewTests"
        )
    ]
)
