import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(
  name: "Joosum",
  dependencies: [
    // Module
    .data(),
    .presentation(),
    // Core
    .core(impl: .Networking),
    // External
    .external(dependency: .Swinject)
  ],
  resources: .default
)
