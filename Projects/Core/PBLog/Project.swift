import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: CoreModule.PBLog.rawValue,
  options: .options(
    textSettings: .textSettings(
      indentWidth: 2,
      tabWidth: 2,
      wrapsLines: true
    )
  ),
  targets: [
    Target(
      name: "\(CoreModule.PBLog.rawValue)Interface",
      platform: .iOS,
      product: .staticFramework,
      bundleId: Project.bundleID + ".\(CoreModule.PBLog.rawValue)Interface".lowercased(),
      deploymentTarget: .iOS(targetVersion: Project.iosVersion, devices: [.iphone, .ipad]),
      infoPlist: .default,
      sources: ["Interfaces/**"],
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
      infoPlist: .default,
      sources: ["Sources/**"],
      dependencies: [
        .target(name: "\(CoreModule.PBLog.rawValue)Interface"),
        // External
        .external(dependency: .RxMoya),
        .external(dependency: .Swinject),
        .external(dependency: .SwiftyJSON)
      ]
    ),
    Target(
      name: "\(CoreModule.PBLog.rawValue)Tests",
      platform: .iOS,
      product: .unitTests,
      bundleId: Project.bundleID + ".\(CoreModule.PBLog.rawValue)Tests".lowercased(),
      deploymentTarget: .iOS(targetVersion: Project.iosVersion, devices: [.iphone, .ipad]),
      infoPlist: .default,
      sources: "Tests/**",
      dependencies: [
        .target(name: "\(CoreModule.PBLog.rawValue)"),
        .target(name: "\(CoreModule.PBLog.rawValue)Interface")
      ]
    )
  ]
)
