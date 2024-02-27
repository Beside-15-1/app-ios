import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.project(
  name: CoreModule.PBNetworking.rawValue,
  targets: [
    Target.target(
      name: CoreModule.PBNetworking.rawValue,
      product: .staticFramework,
      sources: .sources,
      dependencies: [
        // External
        .external(dependency: .RxMoya),
        .external(dependency: .Swinject),
        .external(dependency: .SwiftyJSON),
        .external(dependency: .KeychainAccess),
        // Core
        .core(impl: .PBLog),
      ]
    )
  ]
)
