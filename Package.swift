// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "ToastView",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "ToastView",
            targets: ["ToastView"]
        )
    ],
    targets: [
        .target(
            name: "ToastView"
        )
    ]
)
