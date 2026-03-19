// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "SynthiosKit",
    platforms: [
        .iOS(.v18),
        .macOS(.v15),
    ],
    products: [
        .library(name: "SynthiosProtocol", targets: ["SynthiosProtocol"]),
        .library(name: "SynthiosKit", targets: ["SynthiosKit"]),
        .library(name: "SynthiosChatUI", targets: ["SynthiosChatUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/steipete/ElevenLabsKit", exact: "0.1.0"),
        .package(url: "https://github.com/gonzalezreal/textual", exact: "0.3.1"),
    ],
    targets: [
        .target(
            name: "SynthiosProtocol",
            path: "Sources/SynthiosProtocol",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .target(
            name: "SynthiosKit",
            dependencies: [
                "SynthiosProtocol",
                .product(name: "ElevenLabsKit", package: "ElevenLabsKit"),
            ],
            path: "Sources/SynthiosKit",
            resources: [
                .process("Resources"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .target(
            name: "SynthiosChatUI",
            dependencies: [
                "SynthiosKit",
                .product(
                    name: "Textual",
                    package: "textual",
                    condition: .when(platforms: [.macOS, .iOS])),
            ],
            path: "Sources/SynthiosChatUI",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .testTarget(
            name: "SynthiosKitTests",
            dependencies: ["SynthiosKit", "SynthiosChatUI"],
            path: "Tests/SynthiosKitTests",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
                .enableExperimentalFeature("SwiftTesting"),
            ]),
    ])
