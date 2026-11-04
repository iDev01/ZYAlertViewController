// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "ZYAlertViewController",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "ZYAlertViewController", targets: ["ZYAlertViewController"])
    ],
    targets: [
        .target(
            name: "ZYAlertViewController",
            path: "ZYAlertViewController",
            sources: ["ZYAlertViewController.swift"]
        ),
        .testTarget(name: "ZYAlertViewControllerTests", dependencies: ["ZYAlertViewController"])
    ],
    swiftLanguageVersions: [.v5]
)
