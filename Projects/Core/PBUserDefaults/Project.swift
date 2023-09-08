//
//  CoreModuleCopyFile.swift
//  ProjectDescriptionHelpers
//
//  Created by 박천송 on 2023/05/04.
//

import ProjectDescription
import ProjectDescriptionHelpers

// ************************변경*************************
let moduleName: String = CoreModule.PBUserDefaults.rawValue
// ****************************************************

let project = Project(
  name: moduleName,
  options: .options(
    textSettings: .textSettings(
      indentWidth: 2,
      tabWidth: 2,
      wrapsLines: true
    )
  ),
  targets: [
    Target(
      name: moduleName,
      platform: .iOS,
      product: .staticFramework,
      bundleId: Project.bundleID + ".\(moduleName)".lowercased(),
      deploymentTarget: .iOS(targetVersion: Project.iosVersion, devices: [.iphone, .ipad]),
      infoPlist: .default,
      sources: ["Sources/**"],
      dependencies: [
        // External
        .external(dependency: .Swinject)
      ]
    ),
    Target(
      name: "\(moduleName)Tests",
      platform: .iOS,
      product: .unitTests,
      bundleId: Project.bundleID + ".\(moduleName)Tests".lowercased(),
      deploymentTarget: .iOS(targetVersion: Project.iosVersion, devices: [.iphone, .ipad]),
      infoPlist: .default,
      sources: "Tests/**",
      dependencies: [
        .target(name: "\(moduleName)"),
        .xctest,
        .external(dependency: .RxSwift)
      ]
    ),
  ]
)
