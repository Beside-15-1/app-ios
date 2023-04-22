import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: Module.presentation.name,
  dependencies: [Module.domain.project, Module.designSystem.project],
  resources: .default
)
