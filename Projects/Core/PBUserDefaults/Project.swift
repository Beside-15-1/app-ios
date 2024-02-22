//
//  CoreModuleCopyFile.swift
//  ProjectDescriptionHelpers
//
//  Created by 박천송 on 2023/05/04.
//

import ProjectDescription
import ProjectDescriptionHelpers

// ************************변경*************************
let moduleName: String = CoreModule.PBUserDefaults.rawValue
// ****************************************************

let project = Project.project(
  name: moduleName,
  targets: [
    Target.target(
      name: moduleName,
      product: .staticFramework,
      sources: .sources,
      dependencies: [
        // External
        .external(dependency: .Swinject)
      ]
    )
  ]
)
