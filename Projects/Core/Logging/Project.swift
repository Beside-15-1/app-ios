//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Hohyeon Moon on 2023/05/13.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: CoreModule.Logging.rawValue,
  targets: [
    Target(
      name: "\(CoreModule.Logging.rawValue)Interface",
      platform: .iOS,
      product: .staticFramework,
      bundleId: Project.bundleID + ".\(CoreModule.Logging.rawValue)Interface".lowercased(),
      deploymentTarget: .iOS(targetVersion: Project.iosVersion, devices: [.iphone, .ipad]),
      infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
      sources: ["Interfaces/**"],
      scripts: [.SwiftFormatString],
      dependencies: [
        .rxMoya
      ]
    ),
    Target(
      name: CoreModule.Logging.rawValue,
      platform: .iOS,
      product: .staticFramework,
      bundleId: Project.bundleID + ".\(CoreModule.Logging.rawValue)".lowercased(),
      deploymentTarget: .iOS(targetVersion: Project.iosVersion, devices: [.iphone, .ipad]),
      infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
      sources: ["Sources/**"],
      scripts: [.SwiftFormatString],
      dependencies: [
        .target(name: "\(CoreModule.Logging.rawValue)Interface"),
        // External
        .rxMoya,
        .swinject
      ]
    ),
    Target(
      name: "\(CoreModule.Logging.rawValue)Tests",
      platform: .iOS,
      product: .unitTests,
      bundleId: Project.bundleID + ".\(CoreModule.Logging.rawValue)Tests".lowercased(),
      deploymentTarget: .iOS(targetVersion: Project.iosVersion, devices: [.iphone, .ipad]),
      infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
      sources: "Tests/**",
      scripts: [.SwiftFormatString],
      dependencies: [
        .target(name: "\(CoreModule.Logging.rawValue)"),
        .target(name: "\(CoreModule.Logging.rawValue)Interface")
      ]
    )
  ]
)
