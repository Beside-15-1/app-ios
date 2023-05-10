import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: Module.Domain.rawValue,
  targets: [
    Target(
      name: Module.Domain.rawValue,
      platform: .iOS,
      product: .staticFramework,
      bundleId: Project.bundleID + ".domain",
      deploymentTarget: .iOS(targetVersion: Project.iosVersion, devices: [.iphone, .ipad]),
      infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
      sources: ["Domain/**"],
      scripts: [.SwiftFormatString],
      dependencies: [
        .external(dependency: .RxSwift),
        .external(dependency: .RxCocoa),
        .external(dependency: .RxRelay)
      ]
    ),
    Target(
      name: "Data",
      platform: .iOS,
      product: .staticFramework,
      bundleId: Project.bundleID + ".data",
      deploymentTarget: .iOS(targetVersion: Project.iosVersion, devices: [.iphone, .ipad]),
      infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
      sources: ["Data/**"],
      scripts: [.SwiftFormatString],
      dependencies: [
        .target(name: "Domain"),
        .core(impl: .Networking),
        .external(dependency: .RxSwift),
        .external(dependency: .RxCocoa),
        .external(dependency: .RxRelay),
        .external(dependency: .Swinject),
        .external(dependency: .Moya)
      ]
    ),
    Target(
      name: "\(Module.Domain.rawValue)Tests",
      platform: .iOS,
      product: .unitTests,
      bundleId: Project.bundleID + ".domaintests",
      deploymentTarget: .iOS(targetVersion: Project.iosVersion, devices: [.iphone, .ipad]),
      infoPlist: .file(path: .relativeToRoot("Supporting Files/Info.plist")),
      sources: ["Tests/**"],
      scripts: [.SwiftFormatString],
      dependencies: [
        .target(name: "Domain"),
        .target(name: "Data"),
        .external(dependency: .RxSwift),
        .external(dependency: .RxCocoa),
        .external(dependency: .RxRelay)
      ]
    )
  ]
)
