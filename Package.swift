// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DSWMS",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "DSWMS",
            targets: ["DSWMS"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/fluent-mysql.git", from: "3.0.0"),
        .package(url: "https://github.com/MaherKSantina/DSAuth.git", from: "0.4.8"),
        .package(url: "https://github.com/MaherKSantina/DSWorkshop.git", from: "0.2.4"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "DSWMS",
            dependencies: ["Vapor", "FluentMySQL", "DSAuth", "DSWorkshop"]),
        .testTarget(
            name: "DSWMSTests",
            dependencies: ["DSWMS"]),
    ]
)
