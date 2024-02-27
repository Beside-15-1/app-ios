import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.project(
  name: Module.Domain.rawValue,
  targets: [
    Target.target(
      name: Module.Domain.rawValue,
      product: .staticFramework,
      bundleId: Project.bundleID + ".domain",
      sources: ["Domain/**"],
      dependencies: [
        .external(dependency: .RxSwift),
        .external(dependency: .RxCocoa),
        .external(dependency: .RxRelay),
      ]
    ),
    Target.target(
      name: "Data",
      product: .staticFramework,
      bundleId: Project.bundleID + ".data",
      sources: ["Data/**"],
      dependencies: [
        .target(name: "Domain"),
        .core(impl: .PBNetworking),
        .core(interface: .PBAuth),
        .external(dependency: .RxSwift),
        .external(dependency: .RxCocoa),
        .external(dependency: .RxRelay),
        .external(dependency: .Swinject),
        .external(dependency: .Moya),
        .external(dependency: .SwiftSoup),
      ]
    ),
  ]
)
