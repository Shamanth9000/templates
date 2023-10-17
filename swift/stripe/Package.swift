// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "swift-function",
    dependencies: [
        .package(url: "https://github.com/appwrite/sdk-for-swift.git", from: "4.0.1"),
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.9.0"),
        .package(url: "https://github.com/vapor-community/stripe-kit.git", from: "22.0.0")
    ],
    targets: [
        .executableTarget(
            name: "swift-function",
            dependencies: [
                .product(name: "Appwrite", package: "sdk-for-swift"),
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "StripeKit", package: "stripe-kit")
            ]),
    ]
)