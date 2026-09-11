// swift-tools-version: 5.9
import PackageDescription
let package = Package(name: "FoodMenuCore", platforms: [.macOS(.v12)], targets: [
    .target(name: "FoodMenuCore", path: "FoodApp/Model", exclude: ["SectionModel.swift"], sources: ["Food.swift", "FoodMenu.swift"]),
    .testTarget(name: "FoodMenuCoreTests", dependencies: ["FoodMenuCore"], path: "Tests"),
])
