import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(
  name: "App",
  dependencies: [
    Module.domain.project,
    Module.presentation.project,
    Module.core.project,
    Module.designSystem.project,
    .swinject
  ],
  resources: .default
)
