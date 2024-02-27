import ProjectDescription
import ProjectDescriptionHelpers

let protject = Project.project(
  name: Module.DesignSystem.rawValue,
  targets: [
    Target.target(
      name: Module.DesignSystem.rawValue,
      product: .staticFramework,
      sources: .sources,
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
