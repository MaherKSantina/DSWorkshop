// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DSWorkshop",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "DSWorkshop",
            targets: ["DSWorkshop"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/fluent-mysql.git", from: "3.0.1"),
        .package(url: "https://github.com/MaherKSantina/DSCore.git", from: "0.1.8"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "DSWorkshop",
            dependencies: ["Vapor", "FluentMySQL", "DSCore"]),
        .testTarget(
            name: "DSWorkshopTests",
            dependencies: ["DSWorkshop", "Vapor", "FluentMySQL"]),
    ]
)
