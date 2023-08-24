//
//  CoreModuleCopyFile.swift
//  ProjectDescriptionHelpers
//
//  Created by 박천송 on 2023/05/04.
//

import ProjectDescription
import ProjectDescriptionHelpers

// ************************변경*************************
let moduleName: String = CoreModule.PBNetworking.rawValue
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
      name: "\(moduleName)Interface",
      platform: .iOS,
      product: .staticFramework,
      bundleId: Project.bundleID + ".\(moduleName)Interface".lowercased(),
      deploymentTarget: .iOS(targetVersion: Project.iosVersion, devices: [.iphone]),
      infoPlist: .default,
      sources: ["Interfaces/**"],
      dependencies: []
    ),
    Target(
      name: moduleName,
      platform: .iOS,
      product: .staticFramework,
      bundleId: Project.bundleID + ".\(moduleName)".lowercased(),
      deploymentTarget: .iOS(targetVersion: Project.iosVersion, devices: [.iphone]),
      infoPlist: .default,
      sources: ["Sources/**"],
      dependencies: [
        .target(name: "\(moduleName)Interface"),
        // External
        .external(dependency: .Swinject)
      ]
    ),
    Target(
      name: "\(moduleName)Tests",
      platform: .iOS,
      product: .unitTests,
      bundleId: Project.bundleID + ".\(moduleName)Tests".lowercased(),
      deploymentTarget: .iOS(targetVersion: Project.iosVersion, devices: [.iphone]),
      infoPlist: .default,
      sources: "Tests/**",
      dependencies: [
        .target(name: "\(moduleName)"),
        .target(name: "\(moduleName)Interface"),
        .xctest,
        .external(dependency: .RxSwift)
      ]
    ),
  ]
)
