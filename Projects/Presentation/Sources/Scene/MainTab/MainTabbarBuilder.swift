//
//  MainTabBarBuilder.swift
//  Presentation
//
//  Created by 박천송 on 2023/05/19.
//

import Foundation
import UIKit

import Domain
import PresentationInterface

// MARK: - MainTabBarDependency

struct MainTabBarDependency {}

// MARK: - MainTabBarBuilder

final class MainTabBarBuilder: MainTabBarBuildable {
  private let dependency: MainTabBarDependency

  init(dependency: MainTabBarDependency) {
    self.dependency = dependency
  }

  func build(payload: MainTabBarPayload) -> UITabBarController {
    let viewController = MainTabBarViewController()

    return viewController
  }
}
