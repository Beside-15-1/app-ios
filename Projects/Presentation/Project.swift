import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
  name: Module.Presentation.rawValue,
  targets: [
    Target.target(
      name: "\(Module.Presentation.rawValue)Interface",
      product: .staticFramework,
      sources: .interfaces,
      dependencies: [
        .domain()
      ]
    ),
    Target.target(
      name: Module.Presentation.rawValue,
      product: .staticFramework,
      sources: .sources,
      dependencies: [
        // Target
        .target(name: "\(Module.Presentation.rawValue)Interface"),
        // Module
        .domain(),
        .designSystem(),
        .core(interface: .PBAnalytics),
        .core(impl: .PBUserDefaults),
        // External
        .external(dependency: .ReactorKit),
        .external(dependency: .Swinject),
        .external(dependency: .SDWebImage),
        .external(dependency: .PanModal),
        .external(dependency: .Toaster)
      ]
    )
  ]
)
