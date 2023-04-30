import ProjectDescription
import ProjectDescriptionHelpers

let bundleID = "com.cheonsong"
let iosVersion = "14.0"

let protject = Project(
  name: Module.designSystem.name,
  targets: [
    Target(
      name: "DesignSystem",
      platform: .iOS,
      product: .staticFramework,
      bundleId: bundleID + ".designsystem",
      deploymentTarget: .iOS(targetVersion: iosVersion, devices: [.iphone]),
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
