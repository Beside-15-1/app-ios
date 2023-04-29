//
//  ProjectName.swift
//  ProjectDescriptionHelpers
//
//  Created by cheonsong on 2022/09/02.
//

import ProjectDescription

public enum Module {
  case app
  // Domain
  case domain

  // Presentation
  case presentation

  // DesignSystem
  case designSystem

  // Core
  case core
}

extension Module {
  public var name: String {
    switch self {
    case .app:
      return "App"
    case .presentation:
      return "Presentation"
    case .domain:
      return "Domain"
    case .designSystem:
      return "DesignSystem"
    case .core:
      return "Core"
    }
  }
  
  public var path: ProjectDescription.Path {
    .relativeToRoot("joosum/" + name)
  }

  public var project: TargetDependency {
    .project(target: name, path: path)
  }
}

extension Module: CaseIterable {}
