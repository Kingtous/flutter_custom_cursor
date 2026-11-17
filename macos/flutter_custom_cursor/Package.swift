// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "flutter_custom_cursor",
    platforms: [
        .macOS("10.15")
    ],
    products: [
        .library(name: "flutter-custom-cursor", targets: ["flutter_custom_cursor"])
    ],
    dependencies: [
        // Flutter supplies this local package when building the host app.
        .package(name: "FlutterFramework", path: "../FlutterFramework")
    ],
    targets: [
        .target(
            name: "flutter_custom_cursor",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ]
        )
    ]
)
