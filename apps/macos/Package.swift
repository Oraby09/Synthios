// swift-tools-version: 6.2
// Package manifest for the Synthios macOS companion (menu bar app + IPC library).

import PackageDescription

let package = Package(
    name: "Synthios",
    platforms: [
        .macOS(.v15),
    ],
    products: [
        .library(name: "SynthiosIPC", targets: ["SynthiosIPC"]),
        .library(name: "SynthiosDiscovery", targets: ["SynthiosDiscovery"]),
        .executable(name: "Synthios", targets: ["Synthios"]),
        .executable(name: "synthios-mac", targets: ["SynthiosMacCLI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/orchetect/MenuBarExtraAccess", exact: "1.2.2"),
        .package(url: "https://github.com/swiftlang/swift-subprocess.git", from: "0.1.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.8.0"),
        .package(url: "https://github.com/sparkle-project/Sparkle", from: "2.8.1"),
        .package(url: "https://github.com/steipete/Peekaboo.git", branch: "main"),
        .package(path: "../shared/SynthiosKit"),
        .package(path: "../../Swabble"),
    ],
    targets: [
        .target(
            name: "SynthiosIPC",
            dependencies: [],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .target(
            name: "SynthiosDiscovery",
            dependencies: [
                .product(name: "SynthiosKit", package: "SynthiosKit"),
            ],
            path: "Sources/SynthiosDiscovery",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .executableTarget(
            name: "Synthios",
            dependencies: [
                "SynthiosIPC",
                "SynthiosDiscovery",
                .product(name: "SynthiosKit", package: "SynthiosKit"),
                .product(name: "SynthiosChatUI", package: "SynthiosKit"),
                .product(name: "SynthiosProtocol", package: "SynthiosKit"),
                .product(name: "SwabbleKit", package: "swabble"),
                .product(name: "MenuBarExtraAccess", package: "MenuBarExtraAccess"),
                .product(name: "Subprocess", package: "swift-subprocess"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "Sparkle", package: "Sparkle"),
                .product(name: "PeekabooBridge", package: "Peekaboo"),
                .product(name: "PeekabooAutomationKit", package: "Peekaboo"),
            ],
            exclude: [
                "Resources/Info.plist",
            ],
            resources: [
                .copy("Resources/Synthios.icns"),
                .copy("Resources/DeviceModels"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .executableTarget(
            name: "SynthiosMacCLI",
            dependencies: [
                "SynthiosDiscovery",
                .product(name: "SynthiosKit", package: "SynthiosKit"),
                .product(name: "SynthiosProtocol", package: "SynthiosKit"),
            ],
            path: "Sources/SynthiosMacCLI",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .testTarget(
            name: "SynthiosIPCTests",
            dependencies: [
                "SynthiosIPC",
                "Synthios",
                "SynthiosDiscovery",
                .product(name: "SynthiosProtocol", package: "SynthiosKit"),
                .product(name: "SwabbleKit", package: "swabble"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
                .enableExperimentalFeature("SwiftTesting"),
            ]),
    ])
