// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FirebaseInterface",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "FirestoreProtocol",
            targets: ["FirestoreProtocol"]),
        .library(
            name: "FirestoreRepository",
            targets: ["FirestoreRepository"]),
    ],
    dependencies: [
        .package(name: "Firebase", url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "8.3.0"))
    ],
    targets: [
        .target(
            name: "FirestoreProtocol",
            dependencies: [],
            path: "Sources/FirestoreProtocol"),
        .target(
            name: "FirestoreRepository",
            dependencies: [
                "FirestoreProtocol",
                .product(name: "FirebaseFirestore", package: "Firebase"),
                .product(name: "FirebaseFirestoreSwift-Beta", package: "Firebase")
            ],
            path: "Sources/FirestoreRepository"),
        .testTarget(
            name: "FirestoreRepositoryTests",
            dependencies: [
                "FirestoreRepository",
                .product(name: "FirebaseFirestore", package: "Firebase"),
                .product(name: "FirebaseFirestoreSwift-Beta", package: "Firebase")
            ]),
    ]
)
