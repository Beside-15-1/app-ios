import ProjectDescription
import ProjectDescriptionHelpers

let workspace = Workspace(name: "joosum",
                          projects: Module.allCases.map(\.path))
