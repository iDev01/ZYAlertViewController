// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "ZYAlertViewController",
    platforms: [.iOS(.v9)],
    products: [
        .library(name: "ZYAlertViewController", targets: ["ZYAlertViewController"])
    ],
    targets: [
        .target(
            name: "ZYAlertViewController",
            path: "ZYAlertViewController",
            sources: ["ZYAlertViewController.swift"]
        )
    ],
    swiftLanguageVersions: [.v5]
)
