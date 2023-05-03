import ProjectDescription
import ProjectDescriptionHelpers

let bundleID = "com.pinkboss"
let iosVersion = "14.0"

let project = Project(
  name: Module.Presentation.rawValue,
  targets: [
    Target(
      name: "\(Module.Presentation.rawValue)Interface",
      platform: .iOS,
      product: .staticFramework,
      deploymentTarget: .iOS(targetVersion: iosVersion, devices: [.iphone]),
      bundleId: Project.bundleID + ".\(Module.Presentation.rawValue)Interface",
      infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
      sources: ["Interfaces/**"],
      scripts: [.SwiftFormatString],
      dependencies: [
        .domain()
      ]
    ),
    Target(
      name: Module.Presentation.rawValue,
      platform: .iOS,
      product: .staticFramework,
      deploymentTarget: .iOS(targetVersion: iosVersion, devices: [.iphone]),
      bundleId: Project.bundleID + ".\(Module.Presentation.rawValue)",
      infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
      sources: ["Sources/**"],
      scripts: [.SwiftFormatString],
      dependencies: [
        // Target
        .target(name: "\(Module.Presentation.rawValue)Interface"),
        // Module
        .domain(),
        .designSystem(),
        // External
        .reactorKit,
        .swinject,
        .sdWebImage
      ]
    ),
    Target(
      name: "\(Module.Presentation.rawValue)Tests",
      platform: .iOS,
      product: .unitTests,
      deploymentTarget: .iOS(targetVersion: iosVersion, devices: [.iphone]),
      bundleId: Project.bundleID + ".\(Module.Presentation.rawValue)Tests",
      infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
      sources: "Tests/**",
      scripts: [.SwiftFormatString],
      dependencies: [
        .xctest,
        .target(name: "\(Module.Presentation.rawValue)"),
        .target(name: "\(Module.Presentation.rawValue)Interface"),
        // Module
        .domain()
      ]
    )
  ]
)
