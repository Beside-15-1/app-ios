import ProjectDescription
import ProjectDescriptionHelpers

// ************************변경*************************
let moduleName: String = CoreModule.PBAuth.rawValue
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
      deploymentTarget: .iOS(targetVersion: Project.iosVersion, devices: [.iphone, .ipad]),
      infoPlist: .default,
      sources: ["Interfaces/**"],
      scripts: [
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
      infoPlist: .default,
      sources: ["Sources/**"],
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
      infoPlist: .default,
      sources: "Testing/**",
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
      infoPlist: .default,
      sources: "Tests/**",
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
