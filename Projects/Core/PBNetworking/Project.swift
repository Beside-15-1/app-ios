import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: CoreModule.PBNetworking.rawValue,
  options: .options(
    textSettings: .textSettings(
      indentWidth: 2,
      tabWidth: 2,
      wrapsLines: true
    )
  ),
  targets: [
    Target(
      name: CoreModule.PBNetworking.rawValue,
      platform: .iOS,
      product: .staticFramework,
      bundleId: Project.bundleID + ".\(CoreModule.PBNetworking.rawValue)".lowercased(),
      deploymentTarget: .iOS(targetVersion: Project.iosVersion, devices: [.iphone]),
      infoPlist: .default,
      sources: ["Sources/**"],
      dependencies: [
        // External
        .external(dependency: .RxMoya),
        .external(dependency: .Swinject),
        .external(dependency: .SwiftyJSON),
        .external(dependency: .KeychainAccess),
        // Core
        .core(impl: .PBLog),
      ]
    ),
    Target(
      name: "\(CoreModule.PBNetworking.rawValue)Tests",
      platform: .iOS,
      product: .unitTests,
      bundleId: Project.bundleID + ".\(CoreModule.PBNetworking.rawValue)Tests".lowercased(),
      deploymentTarget: .iOS(targetVersion: Project.iosVersion, devices: [.iphone]),
      infoPlist: .default,
      sources: "Tests/**",
      dependencies: [
        .target(name: "\(CoreModule.PBNetworking.rawValue)")
      ]
    )
  ]
)
