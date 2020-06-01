// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "fluent-postgis",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        // FluentPostgreSQL support for PostGIS
        .library(
            name: "FluentPostGIS",
            targets: ["FluentPostGIS"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/fluent-kit.git", from: "1.0.0-rc.1"),
        .package(url: "https://github.com/vapor/postgres-nio.git", from: "1.0.0"),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.0.0-rc"),

        // Well Known Binary Encoding and Decoding
        .package(url: "https://github.com/rabc/WKCodable", from: "0.1.0"),
    ],
    targets: [
        .target(
            name: "FluentPostGIS",
            dependencies: ["FluentKit", "FluentPostgresDriver", "WKCodable", "PostgresNIO"]),
        .testTarget(
            name: "FluentPostGISTests",
            dependencies: [.target(name: "FluentPostGIS"),
                           .product(name: "FluentBenchmark", package: "fluent-kit")]),
    ]
)
