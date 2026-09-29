// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "edfapay_apple_pay_sheet",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "edfapay-apple-pay-sheet", targets: ["edfapay_apple_pay_sheet"]),
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(
            url: "https://github.com/edfapay/edfapay-spm-distribution.git",
            exact: "1.0.0-beta.2"
        ),
    ],
    targets: [
        .target(
            name: "edfapay_apple_pay_sheet",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "edfapay_pg_sdk", package: "edfapay-spm-distribution"),
            ]
        ),
    ]
)
