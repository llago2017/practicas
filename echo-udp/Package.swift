// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "echo-udp",
    dependencies: [
        .package(name: "Socket", url: "https://github.com/Kitura/BlueSocket.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "echo-server",
            dependencies: ["Socket"]),
        .target(
            name: "echo-client",
            dependencies: ["Socket"]),
    ]
)
