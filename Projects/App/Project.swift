import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.app(name: "App",
                          dependencies: [
                            Module.domain,
                            Module.data,
                            Module.presentation,
                            Module.core,
                            Module.designSystem
                          ].map(\.project),
                          resources: .default)
