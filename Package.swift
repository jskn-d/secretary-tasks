// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "SecretaryTasks",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "SecretaryTasks", targets: ["SecretaryTasks"])
    ],
    targets: [
        .executableTarget(
            name: "SecretaryTasks",
            path: "Sources/SecretaryTasks",
            resources: [
                .process("Resources")
            ]
        )
    ]
)
