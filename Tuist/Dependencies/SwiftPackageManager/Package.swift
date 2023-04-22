// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "PackageName",
    dependencies: [
        .package(url: "https://github.com/ReactiveX/RxSwift", branch: "main"),
        .package(url: "https://github.com/Moya/Moya", branch: "master"),
        .package(url: "https://github.com/SnapKit/SnapKit", .upToNextMinor(from: "5.0.1")),
        .package(url: "https://github.com/devxoul/Then", from: "2.7.0"),
        .package(url: "https://github.com/onevcat/Kingfisher", from: "5.15.6"),
        .package(url: "https://github.com/airbnb/lottie-ios.git", from: "3.2.1"),
        .package(url: "https://github.com/RxSwiftCommunity/RxKeyboard", from: "2.0.0"),
        .package(url: "https://github.com/RxSwiftCommunity/RxGesture", from: "4.0.4"),
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "4.0.0"),
    ]
)