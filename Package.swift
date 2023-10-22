// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "ToastView",
    platforms: [
            .iOS(.v15),
        ],
    products: [
        .library(
            name: "ToastView",
            targets: ["ToastView"]
        ),
    ],
    targets: [
        .target(
            name: "ToastView"
        )
    ]
)
