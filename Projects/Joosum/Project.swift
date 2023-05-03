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
    .swinject
  ],
  resources: .default
)
