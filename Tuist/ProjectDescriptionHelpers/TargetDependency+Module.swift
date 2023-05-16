//
//  TargetDependency+Module.swift
//  ProjectDescriptionHelpers
//
//  Created by 박천송 on 2023/05/04.
//

import ProjectDescription

// MARK: Presentation

extension TargetDependency {
  public static func presentation()-> TargetDependency {
    .project(target: "Presentation", path: .relativeToRoot("Projects/Presentation"))
  }

  public static func presentationTesting()-> TargetDependency {
    .project(target: "PresentationTesting", path: .relativeToRoot("Projects/Presentation"))
  }
}

// MARK: DesignSystem

extension TargetDependency {
  public static func designSystem()-> TargetDependency {
    .project(target: "DesignSystem", path: .relativeToRoot("Projects/DesignSystem"))
  }
}


// MARK: Domain

extension TargetDependency {
  public static func domain()-> TargetDependency {
    .project(target: "Domain", path: .relativeToRoot("Projects/Domain"))
  }

  public static func data()-> TargetDependency {
    .project(target: "Data", path: .relativeToRoot("Projects/Domain"))
  }

  public static func domainTesting()-> TargetDependency {
    .project(target: "DomainTesting", path: .relativeToRoot("Projects/Domain"))
  }
}

// MARK: Core

extension TargetDependency {
  public static func core(impl module: CoreModule)-> TargetDependency {
    .project(target: module.rawValue, path: .relativeToRoot("Projects/Core/" + module.rawValue))
  }

  public static func core(interface module: CoreModule)-> TargetDependency {
    .project(target: module.rawValue + "Interface", path: .relativeToRoot("Projects/Core/" + module.rawValue))
  }
}

