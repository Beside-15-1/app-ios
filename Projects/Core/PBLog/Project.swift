//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Hohyeon Moon on 2023/05/13.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: CoreModule.PBLog.rawValue,
  targets: [
    Target(
      name: "\(CoreModule.PBLog.rawValue)Interface",
      platform: .iOS,
      product: .staticFramework,
      bundleId: Project.bundleID + ".\(CoreModule.PBLog.rawValue)Interface".lowercased(),
      deploymentTarget: .iOS(targetVersion: Project.iosVersion, devices: [.iphone, .ipad]),
      infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
      sources: ["Interfaces/**"],
      scripts: [.SwiftFormatString],
      dependencies: [
        .external(dependency: .RxMoya)
      ]
    ),
    Target(
      name: CoreModule.PBLog.rawValue,
      platform: .iOS,
      product: .staticFramework,
      bundleId: Project.bundleID + ".\(CoreModule.PBLog.rawValue)".lowercased(),
      deploymentTarget: .iOS(targetVersion: Project.iosVersion, devices: [.iphone, .ipad]),
      infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
      sources: ["Sources/**"],
      scripts: [.SwiftFormatString],
      dependencies: [
        .target(name: "\(CoreModule.PBLog.rawValue)Interface"),
        // External
        .external(dependency: .RxMoya),
        .external(dependency: .Swinject)
      ]
    ),
    Target(
      name: "\(CoreModule.PBLog.rawValue)Tests",
      platform: .iOS,
      product: .unitTests,
      bundleId: Project.bundleID + ".\(CoreModule.PBLog.rawValue)Tests".lowercased(),
      deploymentTarget: .iOS(targetVersion: Project.iosVersion, devices: [.iphone, .ipad]),
      infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
      sources: "Tests/**",
      scripts: [.SwiftFormatString],
      dependencies: [
        .target(name: "\(CoreModule.PBLog.rawValue)"),
        .target(name: "\(CoreModule.PBLog.rawValue)Interface")
      ]
    )
  ]
)
