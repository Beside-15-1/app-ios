import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.project(
  name: CoreModule.PBLog.rawValue,
  targets: [
    Target.target(
      name: "\(CoreModule.PBLog.rawValue)Interface",
      product: .staticFramework,
      sources: .interfaces,
      dependencies: [
        .external(dependency: .RxMoya)
      ]
    ),
    Target.target(
      name: CoreModule.PBLog.rawValue,
      product: .staticFramework,
      sources: .sources,
      dependencies: [
        .target(name: "\(CoreModule.PBLog.rawValue)Interface"),
        // External
        .external(dependency: .RxMoya),
        .external(dependency: .Swinject),
        .external(dependency: .SwiftyJSON)
      ]
    ),
  ]
)
