import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: CoreModule.Networking.rawValue,
  targets: [
    Target(
      name: CoreModule.Networking.rawValue,
      platform: .iOS,
      product: .staticFramework,
      bundleId: Project.bundleID + ".\(CoreModule.Networking.rawValue)".lowercased(),
      deploymentTarget: .iOS(targetVersion: Project.iosVersion, devices: [.iphone, .ipad]),
      infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
      sources: ["Sources/**"],
      scripts: [.SwiftFormatString],
      dependencies: [
        // External
        .rxMoya,
        .swinject
      ]
    ),
    Target(
      name: "\(CoreModule.Networking.rawValue)Tests",
      platform: .iOS,
      product: .unitTests,
      bundleId: Project.bundleID + ".\(CoreModule.Networking.rawValue)Tests".lowercased(),
      deploymentTarget: .iOS(targetVersion: Project.iosVersion, devices: [.iphone, .ipad]),
      infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
      sources: "Tests/**",
      scripts: [.SwiftFormatString],
      dependencies: [
        .target(name: "\(CoreModule.Networking.rawValue)")
      ]
    )
  ]
)
