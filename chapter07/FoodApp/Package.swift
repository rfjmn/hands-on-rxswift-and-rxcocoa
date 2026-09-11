// swift-tools-version: 5.9
import PackageDescription
let package = Package(name: "FoodMenuCore", platforms: [.macOS(.v12)], dependencies: [
    .package(url: "https://github.com/ReactiveX/RxSwift.git", exact: "6.7.1")
], targets: [
    .target(name: "FoodMenuCore", dependencies: [.product(name: "RxSwift", package: "RxSwift")], path: "FoodApp", exclude: ["AppDelegate.swift", "SceneDelegate.swift", "Assets.xcassets", "Base.lproj", "Info.plist", "previousEpisodes", "Model/SectionModel.swift", "View/FoodDetailView", "View/FoodTableView/FoodTableViewCell.swift", "View/FoodTableView/ViewController.swift"], sources: ["Model/Food.swift", "Model/FoodMenu.swift", "View/FoodTableView/FoodListViewModel.swift"]),
    .testTarget(name: "FoodMenuCoreTests", dependencies: ["FoodMenuCore"], path: "Tests")
])
