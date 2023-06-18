import Foundation
import UIKit

import Domain
import PresentationInterface

// MARK: - LinkBookDependency

struct LinkBookDependency {}

// MARK: - LinkBookBuilder

final class LinkBookBuilder: LinkBookBuildable {
  private let dependency: LinkBookDependency

  init(dependency: LinkBookDependency) {
    self.dependency = dependency
  }

  func build(payload: LinkBookPayload) -> UIViewController {
    let viewModel = LinkBookViewModel()

    let viewController = LinkBookViewController(
      viewModel: viewModel
    )

    return viewController
  }
}
