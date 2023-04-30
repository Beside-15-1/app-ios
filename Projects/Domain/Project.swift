import ProjectDescription
import ProjectDescriptionHelpers

// let project = Project.framework(
//  name: Module.domain.name,
//  dependencies: [.rxSwift, .rxCocoa, .rxRelay]
// )

let bundleID = "com.cheonsong"
let iosVersion = "14.0"

let protject = Project(
  name: Module.domain.name,
  targets: [
    Target(
      name: "Domain",
      platform: .iOS,
      product: .staticFramework,
      bundleId: bundleID + ".domain",
      deploymentTarget: .iOS(targetVersion: iosVersion, devices: [.iphone]),
      infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
      sources: ["Domain/**"],
      scripts: [.SwiftFormatString],
      dependencies: [
        .rxSwift,
        .rxCocoa,
        .rxRelay,
      ]
    ),
    Target(
      name: "Data",
      platform: .iOS,
      product: .staticFramework,
      bundleId: bundleID + ".data",
      deploymentTarget: .iOS(targetVersion: iosVersion, devices: [.iphone]),
      infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
      sources: ["Data/**"],
      scripts: [.SwiftFormatString],
      dependencies: [
        .target(name: "Domain"),
        Module.core.project,
        .rxSwift,
        .rxCocoa,
        .rxRelay,
        .swinject,
      ]
    ),
    Target(
      name: "DomainTests",
      platform: .iOS,
      product: .unitTests,
      bundleId: bundleID + ".domain",
      deploymentTarget: .iOS(targetVersion: iosVersion, devices: [.iphone]),
      infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
      sources: ["Tests/**"],
      scripts: [.SwiftFormatString],
      dependencies: [
        .rxSwift,
        .rxCocoa,
        .rxRelay,
      ]
    ),
  ]
)
