import ProjectDescription
import ProjectDescriptionHelpers

let bundleID = "com.pinkboss"
let iosVersion = "14.0"
let project = Project(
  name: Module.Domain.rawValue,
  targets: [
    Target(
      name: Module.Domain.rawValue,
      platform: .iOS,
      product: .staticFramework,
      deploymentTarget: .iOS(targetVersion: iosVersion, devices: [.iphone]),
      bundleId: Project.bundleID + ".domain",
      infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
      sources: ["Domain/**"],
      scripts: [.SwiftFormatString],
      dependencies: [
        .rxSwift,
        .rxCocoa,
        .rxRelay
      ]
    ),
    Target(
      name: "Data",
      platform: .iOS,
      product: .staticFramework,
      deploymentTarget: .iOS(targetVersion: iosVersion, devices: [.iphone]),
      bundleId: Project.bundleID + ".data",
      infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
      sources: ["Data/**"],
      scripts: [.SwiftFormatString],
      dependencies: [
        .target(name: "Domain"),
        .rxSwift,
        .rxCocoa,
        .rxRelay,
        .swinject
      ]
    ),
    Target(
      name: "\(Module.Domain.rawValue)Tests",
      platform: .iOS,
      product: .unitTests,
      deploymentTarget: .iOS(targetVersion: iosVersion, devices: [.iphone]),
      bundleId: Project.bundleID + ".domaintests",
      infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
      sources: ["Tests/**"],
      scripts: [.SwiftFormatString],
      dependencies: [
        .target(name: "Domain"),
        .target(name: "Data"),
        .rxSwift,
        .rxCocoa,
        .rxRelay
      ]
    )
  ]
)
