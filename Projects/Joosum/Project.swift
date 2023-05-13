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
    .core(impl: .Logging),
    // External
    .swinject
  ],
  resources: .default
)
