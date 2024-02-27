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
  organizationName: "Pink Boss Inc",
  options: .options(
    textSettings: .textSettings(
      indentWidth: 2,
      tabWidth: 2,
      wrapsLines: true
    )
  ),
  targets: [
    Target.target(
      name: "\(moduleName)Interface",
      destinations: .init([.iPad, .iPhone]),
      product: .staticFramework,
      bundleId: Project.bundleID + ".\(moduleName)Interface".lowercased(),
      deploymentTargets: .iOS(Project.iosVersion),
      infoPlist: .default,
      sources: ["Interfaces/**"],
      dependencies: []
    ),
    Target.target(
      name: moduleName,
      destinations: .init([.iPad, .iPhone]),
      product: .staticFramework,
      bundleId: Project.bundleID + ".\(moduleName)".lowercased(),
      deploymentTargets: .iOS(Project.iosVersion),
      infoPlist: .default,
      sources: ["Sources/**"],
      dependencies: [
        .target(name: "\(moduleName)Interface"),
        // External
        .external(dependency: .Swinject),
      ]
    ),
    Target.target(
      name: "\(moduleName)Tests",
      destinations: .init([.iPad, .iPhone]),
      product: .unitTests,
      bundleId: Project.bundleID + ".\(moduleName)Tests".lowercased(),
      deploymentTargets: .iOS(Project.iosVersion),
      infoPlist: .default,
      sources: ["Tests/**"],
      dependencies: [
        .target(name: "\(moduleName)"),
        .target(name: "\(moduleName)Interface"),
        .xctest,
        .external(dependency: .RxSwift),
      ]
    ),
  ]
)
