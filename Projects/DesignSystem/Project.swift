import ProjectDescription
import ProjectDescriptionHelpers

let protject = Project(
  name: Module.DesignSystem.rawValue,
  options: .options(
    textSettings: .textSettings(
      indentWidth: 2,
      tabWidth: 2,
      wrapsLines: true
    )
  ),
  targets: [
    Target(
      name: Module.DesignSystem.rawValue,
      platform: .iOS,
      product: .staticFramework,
      bundleId: Project.bundleID + ".\(Module.DesignSystem.rawValue)".lowercased(),
      deploymentTarget: .iOS(targetVersion: Project.iosVersion, devices: [.iphone]),
      infoPlist: .default,
      sources: ["Sources/**"],
      resources: .default,
      dependencies: [
        .external(dependency: .SnapKit),
        .external(dependency: .Then),
        .external(dependency: .RxSwift),
        .external(dependency: .RxCocoa),
        .external(dependency: .RxRelay)
      ]
    )
  ]
)
