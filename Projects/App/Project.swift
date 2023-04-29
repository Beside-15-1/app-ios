import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(
  name: "App",
  dependencies: [
    .project(target: "Domain", path: .relativeToRoot("joosum/Domain")),
    Module.presentation.project,
    Module.core.project,
    Module.designSystem.project,
  ],
  resources: .default
)
