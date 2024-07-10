import Foundation
import UIKit

import Domain
import PresentationInterface

// MARK: - MainTabBarDependency

struct MainTabBarDependency {
  let homeBuilder: HomeBuildable
  let homeFeedBuilder: HomeFeedBuildable
  let myFolderBuilder: MyFolderBuildable
  let myPageBuilder: MyPageBuildable
}

// MARK: - MainTabBarBuilder

final class MainTabBarBuilder: MainTabBarBuildable {
  private let dependency: MainTabBarDependency

  init(dependency: MainTabBarDependency) {
    self.dependency = dependency
  }

  func build(payload: MainTabBarPayload) -> UITabBarController {
    let viewController = MainTabBarViewController(
      homeBuilder: dependency.homeBuilder,
      homeFeedBuilder: dependency.homeFeedBuilder,
      folderBuilder: dependency.myFolderBuilder,
      myPageBuilder: dependency.myPageBuilder
    )

    return viewController
  }
}
