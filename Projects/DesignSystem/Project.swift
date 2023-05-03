import ProjectDescription
import ProjectDescriptionHelpers

let bundleID = "com.pinkboss"
let iosVersion = "14.0"

let protject = Project(
  name: Module.DesignSystem.rawValue,
  targets: [
    Target(
      name: Module.DesignSystem.rawValue,
      platform: .iOS,
      product: .staticFramework,
      deploymentTarget: .iOS(targetVersion: iosVersion, devices: [.iphone]),
      bundleId: Project.bundleID + ".\(Module.DesignSystem.rawValue)".lowercased(),
      infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
      sources: ["Sources/**"],
      resources: .default,
      scripts: [.SwiftFormatString],
      dependencies: [
        .snapKit,
        .then
      ]
    )
  ]
)
