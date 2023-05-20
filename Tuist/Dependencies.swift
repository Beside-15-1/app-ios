//
//  Dependencies.swift
//  Config
//
//  Created by cheonsong on 2022/09/05.
//

import ProjectDescription

let dependencies = Dependencies(
  carthage: [],
  swiftPackageManager: [
    .rxSwift,
    .moya,
    .snapKit,
    .then,
    .lottie,
    .rxKeyboard,
    .rxGesture,
    .swiftyJson,
    .reactorKit,
    .swinject,
    .sdWebImage,
    .firebase
  ],
  platforms: [.iOS]
)

extension Package {
  public static let rxSwift: Package = .remote(
    url: "https://github.com/ReactiveX/RxSwift",
    requirement: .branch("main")
  )
  public static let moya: Package = .remote(
    url: "https://github.com/Moya/Moya",
    requirement: .branch("master")
  )
  public static let snapKit: Package = .remote(
    url: "https://github.com/SnapKit/SnapKit",
    requirement: .upToNextMinor(from: "5.0.1")
  )
  public static let then: Package = .remote(
    url: "https://github.com/devxoul/Then",
    requirement: .upToNextMajor(from: "2.7.0")
  )
  public static let lottie: Package = .remote(
    url: "https://github.com/airbnb/lottie-ios.git",
    requirement: .upToNextMajor(from: "3.2.1")
  )
  public static let rxKeyboard: Package = .remote(
    url: "https://github.com/RxSwiftCommunity/RxKeyboard",
    requirement: .upToNextMajor(from: "2.0.0")
  )
  public static let rxGesture: Package = .remote(
    url: "https://github.com/RxSwiftCommunity/RxGesture",
    requirement: .upToNextMajor(from: "4.0.4")
  )
  public static let swiftyJson: Package = .remote(
    url: "https://github.com/SwiftyJSON/SwiftyJSON.git",
    requirement: .upToNextMajor(from: "4.0.0")
  )
  public static let reactorKit: Package = .remote(
    url: "https://github.com/ReactorKit/ReactorKit.git",
    requirement: .upToNextMajor(from: "3.0.0")
  )
  public static let swinject: Package = .remote(
    url: "https://github.com/Swinject/Swinject",
    requirement: .upToNextMajor(from: "2.0.0")
  )
  public static let sdWebImage: Package = .remote(
    url: "https://github.com/SDWebImage/SDWebImage.git",
    requirement: .upToNextMajor(from: "5.0.0")
  )
  public static let firebase: Package = .remote(
    url: "https://github.com/firebase/firebase-ios-sdk.git",
    requirement: .upToNextMajor(from: "10.4.0")
  )
}
