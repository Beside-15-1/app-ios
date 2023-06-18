import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: CoreModule.PBNetworking.rawValue,
  targets: [
    Target(
      name: CoreModule.PBNetworking.rawValue,
      platform: .iOS,
      product: .staticFramework,
      bundleId: Project.bundleID + ".\(CoreModule.PBNetworking.rawValue)".lowercased(),
      deploymentTarget: .iOS(targetVersion: Project.iosVersion, devices: [.iphone, .ipad]),
      infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
      sources: ["Sources/**"],
      scripts: [.SwiftFormatString],
      dependencies: [
        // External
        .external(dependency: .RxMoya),
        .external(dependency: .Swinject),
        .external(dependency: .SwiftyJSON),
        // Core
        .core(impl: .PBLog)
      ]
    ),
    Target(
      name: "\(CoreModule.PBNetworking.rawValue)Tests",
      platform: .iOS,
      product: .unitTests,
      bundleId: Project.bundleID + ".\(CoreModule.PBNetworking.rawValue)Tests".lowercased(),
      deploymentTarget: .iOS(targetVersion: Project.iosVersion, devices: [.iphone, .ipad]),
      infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
      sources: "Tests/**",
      scripts: [.SwiftFormatString],
      dependencies: [
        .target(name: "\(CoreModule.PBNetworking.rawValue)")
      ]
    )
  ]
)
