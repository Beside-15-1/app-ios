import ProjectDescription
import ProjectDescriptionHelpers

let bundleID = "com.cheonsong"
let iosVersion = "14.0"

let project = Project(
  name: Module.presentation.name,
  targets: [
    Target(
      name: "\(Module.presentation.name)Interface",
      platform: .iOS,
      product: .staticFramework,
      bundleId: bundleID,
      deploymentTarget: .iOS(targetVersion: iosVersion, devices: [.iphone]),
      infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
      sources: ["Interfaces/**"],
      scripts: [.SwiftFormatString],
      dependencies: []
    ),
    Target(
      name: Module.presentation.name,
      platform: .iOS,
      product: .staticFramework,
      bundleId: bundleID,
      deploymentTarget: .iOS(targetVersion: iosVersion, devices: [.iphone]),
      infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
      sources: ["Sources/**"],
      scripts: [.SwiftFormatString],
      dependencies: [
        .target(name: "\(Module.designSystem.project)Interface"),
        Module.designSystem.project,
        .reactorKit,
        .swinject,
        .sdWebImage
      ]
    ),
    Target(
      name: "\(Module.presentation.name)Tests",
      platform: .iOS,
      product: .unitTests,
      bundleId: bundleID,
      deploymentTarget: .iOS(targetVersion: iosVersion, devices: [.iphone]),
      infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
      sources: "Tests/**",
      scripts: [.SwiftFormatString],
      dependencies: [
        .target(name: "\(Module.presentation.name)"),
        .target(name: "\(Module.presentation.name)Interface")
      ]
    )
  ]
)
