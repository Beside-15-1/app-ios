//
//  CoreModuleCopyFile.swift
//  ProjectDescriptionHelpers
//
//  Created by 박천송 on 2023/05/04.
//

import ProjectDescription
import ProjectDescriptionHelpers

// ************************변경*************************
let moduleName: String = CoreModule.PBAuth.rawValue
// ****************************************************

let project = Project(
  name: moduleName,
  targets: [
    Target(
      name: "\(moduleName)Interface",
      platform: .iOS,
      product: .staticFramework,
      bundleId: Project.bundleID + ".\(moduleName)Interface".lowercased(),
      deploymentTarget: .iOS(targetVersion: Project.iosVersion, devices: [.iphone, .ipad]),
      infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
      sources: ["Interfaces/**"],
      scripts: [.SwiftFormatString] + [
        TargetScript.pre(
          script: #"""
          export PATH="$PATH:/opt/homebrew/bin"

          if which mockolo; then
            mockolo -s Interfaces -d Testing/PBAuthMocks.swift -i PBAuthInterface --enable-args-history --mock-final
          else
            echo "warning: mockolo not installed, download from https://github.com/uber/mockolo using Homebrew"
          fi
          """#,
          name: "Mockolo",
          outputPaths: ["Testing/PBAuthMocks.swift"],
          basedOnDependencyAnalysis: false
        )
      ],
      dependencies: [
        .external(dependency: .FirebaseAnalytics)
      ]
    ),
    Target(
      name: moduleName,
      platform: .iOS,
      product: .staticFramework,
      bundleId: Project.bundleID + ".\(moduleName)".lowercased(),
      deploymentTarget: .iOS(targetVersion: Project.iosVersion, devices: [.iphone, .ipad]),
      infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
      sources: ["Sources/**"],
      scripts: [.SwiftFormatString],
      dependencies: [
        .target(name: "\(moduleName)Interface"),
        // External
        .external(dependency: .Swinject),
        .external(dependency: .KeychainAccess)
      ],
      settings: .settings(
        base: ["OTHER_LDFLAGS": "$(inherited) -ObjC"],
        configurations: []
      )
    ),
    Target(
      name: "\(moduleName)Testing",
      platform: .iOS,
      product: .staticLibrary,
      bundleId: Project.bundleID + ".\(moduleName)Testing".lowercased(),
      deploymentTarget: .iOS(targetVersion: Project.iosVersion, devices: [.iphone, .ipad]),
      infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
      sources: "Testing/**",
      scripts: [.SwiftFormatString],
      dependencies: [
        .target(name: "\(moduleName)Interface")
      ]
    ),
    Target(
      name: "\(moduleName)Tests",
      platform: .iOS,
      product: .unitTests,
      bundleId: Project.bundleID + ".\(moduleName)Tests".lowercased(),
      deploymentTarget: .iOS(targetVersion: Project.iosVersion, devices: [.iphone, .ipad]),
      infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
      sources: "Tests/**",
      scripts: [.SwiftFormatString],
      dependencies: [
        .target(name: "\(moduleName)"),
        .target(name: "\(moduleName)Interface"),
        .target(name: "\(moduleName)Testing"),
        .xctest,
        .external(dependency: .RxSwift),
        .external(dependency: .Nimble)
      ]
    )
  ]
)
