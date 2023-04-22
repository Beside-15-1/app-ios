import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
  name: Module.core.name,
  dependencies: [.rxMoya]
)
