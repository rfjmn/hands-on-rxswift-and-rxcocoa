// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "chapter04",
    dependencies: [
        .package(url:"https://github.com/ReactiveX/RxSwift.git", from: "6.5.0")
    ],
    targets: [
        .executableTarget(
            name: "chapter04",
            dependencies: ["RxSwift", .product(name: "RxCocoa", package: "RxSwift")]),
        .testTarget(
            name: "chapter04Tests",
            dependencies: ["chapter04", .product(name: "RxTest", package: "RxSwift")]),
    ]
)
