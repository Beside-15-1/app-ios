import ProjectDescription
import ProjectDescriptionHelpers

let protject = Project(
  name: Module.DesignSystem.rawValue,
  targets: [
    Target(
      name: Module.DesignSystem.rawValue,
      platform: .iOS,
      product: .staticFramework,
      bundleId: Project.bundleID + ".\(Module.DesignSystem.rawValue)".lowercased(),
      deploymentTarget: .iOS(targetVersion: Project.iosVersion, devices: [.iphone, .ipad]),
      infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
      sources: ["Sources/**"],
      resources: .default,
      dependencies: [
        .snapKit,
        .then
      ]
    )
  ]
)
