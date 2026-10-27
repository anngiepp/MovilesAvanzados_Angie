// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "BoletaCore",
    platforms: [.macOS(.v13)],
    products: [.library(name: "BoletaCore", targets: ["BoletaCore"])],
    targets: [
        .target(name: "BoletaCore", path: "BoletaPagoApp", exclude: ["Views", "BoletaPagoApp.swift"]),
        .testTarget(name: "BoletaCoreTests", dependencies: ["BoletaCore"], path: "BoletaPagoAppTests")
    ]
)
