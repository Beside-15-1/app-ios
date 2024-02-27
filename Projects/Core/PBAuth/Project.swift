import ProjectDescription
import ProjectDescriptionHelpers

// ************************변경*************************
let moduleName: String = CoreModule.PBAuth.rawValue
// ****************************************************

let project = Project.project(
  name: moduleName,
  targets: [
    Target.target(
      name: "\(moduleName)Interface",
      product: .staticFramework,
      sources: .interfaces,
      dependencies: [
        .external(dependency: .FirebaseAnalytics)
      ]
    ),
    Target.target(
      name: moduleName,
      product: .staticFramework,
      sources: .sources,
      dependencies: [
        .target(name: "\(moduleName)Interface"),
        // External
        .external(dependency: .Swinject),
        .external(dependency: .KeychainAccess)
      ],
      settings: .settings(
        base: ["OTHER_LDFLAGS": "$(inherited) -ObjC"],
        configurations: []
      )
    ),
  ]
)
