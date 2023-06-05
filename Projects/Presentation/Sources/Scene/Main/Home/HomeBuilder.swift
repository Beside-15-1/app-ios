import Foundation
import UIKit

import Domain
import PresentationInterface

// MARK: - HomeDependency

struct HomeDependency {}

// MARK: - HomeBuilder

final class HomeBuilder: HomeBuildable {
  private let dependency: HomeDependency

  init(dependency: HomeDependency) {
    self.dependency = dependency
  }

  func build(payload: HomePayload) -> UIViewController {
    let viewModel = HomeViewModel()

    let viewController = HomeViewController(
      viewModel: viewModel
    )

    return viewController
  }
}
