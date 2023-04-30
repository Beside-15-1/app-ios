import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(
  name: "App",
  dependencies: [
    .project(target: "Data", path: .relativeToRoot("Projects/Domain")),
    Module.presentation.project,
    Module.core.project,
    .swinject
  ],
  resources: .default
)
